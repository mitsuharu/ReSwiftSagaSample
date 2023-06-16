//
//  SagaMonitor.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/16.
//

import Foundation
import ReSwift
import Combine

/**
 Saga向けのAction
 - Actionの比較が必要なため、Hashable を継承した
 */
protocol SagaAction: Action, Hashable {}

extension SagaAction {
    
    /**
     SagaActionの比較関数
     - プロトコルでは直接比較(==)できないための回避策です
     */
    func isEqualTo(_ arg: any SagaAction) -> Bool {
        return self.hashValue == arg.hashValue
    }
}

/**
 Sagaで実行する関数の型
 */
typealias Saga<T> = (_ action: (any SagaAction)?) async -> T

/**
 構造体 SagaEffect でサポートする副作用
 */
enum SagaPattern {
    case take
    case takeEvery
    case takeLeading
    case takeLatest
}

struct SagaEffect<T>: Hashable {
    
    let identifier = UUID().uuidString
        
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    static func == (lhs: SagaEffect<T>, rhs: SagaEffect<T>) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    let pattern: SagaPattern
    let action: (any SagaAction)?
    let saga: Saga<T>?
}

/**
 SagaMonitor
 - 中核となるクラス
 - 発行された Action の監視して、それぞれのルールに従って処理を行う
 */
final class SagaMonitor {
    
    public static let shared = SagaMonitor()
    
    private let subject = PassthroughSubject<any SagaAction, Error>()
    private var effects = Set<SagaEffect<Any>>()
    private var cancellable: AnyCancellable? = nil
    private var currentTasks = [String:Task<(), Never>]()

    init() {
        observe()
    }
    
    /**
     action を発行する
     */
    func send(_ action: any SagaAction){
        subject.send(action)
    }
    
    /**
     takeEveryなどの副作用を記録する
     */
    func addEffect(_ effect:SagaEffect<Any>){
        effects.insert(effect)
    }
    
    /**
     middlewareから発行されるactionを受け取る
     */
    private func observe(){
        cancellable = subject.sink { [weak self] in
            self?.complete($0)
        } receiveValue: { [weak self] action in
            // 発行されたactionに対する副作用があれば、逐次実行する
            self?.effects.filter { $0.action?.isEqualTo(action) == true }.forEach({ effect in
                self?.execute(effect)
            })
        }
    }
    
    /**
     副作用をそれぞれのタイミングで実行する
     */
    private func execute(_ effect: SagaEffect<Any>) {
        switch effect.pattern {
        case .takeEvery:
            if let saga = effect.saga{
                Task.detached{
                    let _ = await saga(effect.action)
                }
            }
            
        case .takeLatest:
            if let saga = effect.saga{
                currentTasks[effect.identifier]?.cancel()
                currentTasks[effect.identifier] = nil
                currentTasks[effect.identifier] = Task.detached{
                    let _ = await saga(effect.action)
                    self.currentTasks[effect.identifier]?.cancel()
                    self.currentTasks[effect.identifier] = nil
                }
            }
            
        case .takeLeading:
            if let saga = effect.saga{
                if self.currentTasks[effect.identifier] != nil {
                    return
                }
                currentTasks[effect.identifier] = Task.detached{
                    let _ = await saga(effect.action)
                    self.currentTasks[effect.identifier]?.cancel()
                    self.currentTasks[effect.identifier] = nil
                }
            }
            
        default:
            break
        }
        
    }
    
    /**
     特定の action を監視して、イベントを実行する。主に take 向け。
     */
    func match(_ action: any SagaAction, receive: @escaping (_ action: any SagaAction) -> Void ){
        // 監視は一度限りで行い、検出後は破棄する
        // 破棄しないと、検出した action を対応にした場合、withCheckedContinuation で二重呼び出しにカウントされクラッシュする
        var cancellable: AnyCancellable? = nil
        
        cancellable =  subject.filter {
            $0.isEqualTo(action)
        }.sink { [weak self] in
            self?.complete($0)
            cancellable?.cancel()
        } receiveValue: {
            receive($0)
            cancellable?.cancel()
        }
    }
    
    func cancel() {
        effects.removeAll()
        cancellable?.cancel()
        currentTasks.values.forEach { $0.cancel() }
    }
    
    /**
     エラー時の処理
     @TODO: エラーを投げるかは検討
     */
    private func complete(_ completion: Subscribers.Completion<Error>){
        switch completion {
        case .finished:
            print("SagaMonitor#finished")
        case .failure(let error):
            assertionFailure("SagaMonitor#failure \(error)")
        }
    }
}
