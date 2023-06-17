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
 Action のクラス
 一般的に enum や struct が使われることが多いが、
 Actionのmoduleごとのグルーピングなどに継承を利用するためにclassを利用する
 */
class SagaAction: Action {
}

/**
 Sagaで実行する関数の型
 */
typealias Saga<T> = (SagaAction) async -> T

/**
 構造体 SagaStore でサポートする副作用
 */
enum SagaPattern {
    case take
    case takeEvery
    case takeLeading
    case takeLatest
}

struct SagaStore<T>: Hashable {
    
    let identifier = UUID().uuidString
        
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    static func == (lhs: SagaStore<T>, rhs: SagaStore<T>) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    let pattern: SagaPattern
    let type: SagaAction.Type
    let saga: Saga<T>
}

/**
 SagaMonitor
 - 中核となるクラス
 - 発行された Action の監視して、それぞれのルールに従って処理を行う
 */
final class SagaMonitor {
    
    public static let shared = SagaMonitor()
    
    private let subject = PassthroughSubject<SagaAction, Error>()
    private var stores = Set<SagaStore<Any>>()
    private var cancellable: AnyCancellable? = nil
    private var currentTasks = [String:Task<(), Never>]()

    init() {
        observe()
    }
    
    /**
     action を発行する
     */
    func send(_ action: SagaAction){
        subject.send(action)
    }
    
    /**
     takeEveryなどの副作用を記録する
     */
    func addStore(_ store:SagaStore<Any>){
        stores.insert(store)
    }
    
    /**
     middlewareから発行されるactionを受け取る
     */
    private func observe(){
        cancellable = subject.sink { [weak self] in
            self?.complete($0)
        } receiveValue: { [weak self] action in
            // 発行されたactionに対する副作用があれば、逐次実行する
             self?.stores.filter { $0.type == type(of: action) }.forEach({ effect in
                 self?.execute(effect, action: action)
            })
        }
    }
    
    /**
     副作用をそれぞれのタイミングで実行する
     */
    private func execute(_ effect: SagaStore<Any>, action: SagaAction) {
        print("execute pattern:", effect.pattern, "action:", action)
        
        switch effect.pattern {
        case .takeEvery:
            Task.detached{
                let _ = await effect.saga(action)
            }
            
        case .takeLatest:
            currentTasks[effect.identifier]?.cancel()
            currentTasks[effect.identifier] = nil
            currentTasks[effect.identifier] = Task.detached{
                let _ = await effect.saga(action)
                self.currentTasks[effect.identifier]?.cancel()
                self.currentTasks[effect.identifier] = nil
            }

        case .takeLeading:
            if self.currentTasks[effect.identifier] != nil {
                return
            }
            currentTasks[effect.identifier] = Task.detached{
                let _ = await effect.saga(action)
                self.currentTasks[effect.identifier]?.cancel()
                self.currentTasks[effect.identifier] = nil
            }
            
        default:
            break
        }
    }
    
    /**
     特定の action を監視して、イベントを実行する。主に take 向け。
     */
    func match(_ actionType: SagaAction.Type, receive: @escaping (_ action: SagaAction) -> Void ){
        // 監視は一度限りで行い、検出後は破棄する
        // 破棄しないと、検出した action を対応にした場合、withCheckedContinuation で二重呼び出しにカウントされクラッシュする
        var cancellable: AnyCancellable? = nil

        cancellable =  subject.filter {
            type(of: $0) == actionType
        }.sink { [weak self] in
            self?.complete($0)
            cancellable?.cancel()
        } receiveValue: {
            receive($0)
            cancellable?.cancel()
        }
    }
    
    func cancel() {
        stores.removeAll()
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
