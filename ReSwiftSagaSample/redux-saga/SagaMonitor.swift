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
 Sagaで実行する関数の型
 */
//typealias Saga<T> = ((any Action)?) async -> T

typealias Saga<T, K> = (T?) async -> K


struct ActionStruct: Action {}

/**
 構造体 SagaEffect でサポートする副作用
 */
enum SagaPattern {
    case take
    case takeEvery
    case takeLeading
    case takeLatest
}

struct SagaEffect<T, K>: Hashable {
    
    let identifier = UUID().uuidString
        
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    static func == (lhs: SagaEffect<T, K>, rhs: SagaEffect<T, K>) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    let pattern: SagaPattern
    let type: any Action.Type
    let saga: Saga<T, K>?
}


public let sagaMonitor = SagaMonitor<any Action, Any>()


/**
 SagaMonitor
 - 中核となるクラス
 - 発行された Action の監視して、それぞれのルールに従って処理を行う
 */
public final class SagaMonitor<T, K> {
    
    // public static let shared = SagaMonitor<Action, Void>()
    
    private let subject = PassthroughSubject<any Action, Error>()
    private var effects = Set<SagaEffect<T, K>>()
    private var cancellable: AnyCancellable? = nil
    private var currentTasks = [String:Task<(), Never>]()

    init() {
        observe()
    }
    
    /**
     action を発行する
     */
    func send(_ action:  any Action){
        subject.send(action)
    }
    
    /**
     takeEveryなどの副作用を記録する
     */
    func addEffect(_ effect:SagaEffect<T, K>){
        effects.insert(effect)
    }
    
    /**
     middlewareから発行されるactionを受け取る
     */
    private func observe(){
        cancellable = subject.sink { [weak self] in
            self?.complete($0)
        } receiveValue: { [weak self] action in
            
            print("observe", action, action.self)
        
            self?.effects.forEach {
                print("observe $0.type:", $0.type, "type(of: action):", type(of: action), $0.type == type(of: action))
      
                
            }
            // 発行されたactionに対する副作用があれば、逐次実行する
             self?.effects.filter { $0.type == type(of: action) }.forEach({ effect in
                 self?.execute(effect, action: action)
            })
        }
    }
    
    /**
     副作用をそれぞれのタイミングで実行する
     */
    private func execute(_ effect: SagaEffect<T, K>, action: any Action) {
        print("execute pattern:", effect.pattern, "action:", action)
        
        switch effect.pattern {
        case .takeEvery:
            print("execute pattern:", effect.pattern, "action:", action, "saga:", effect.saga != nil )
            if let saga = effect.saga{
                Task.detached{
                    let _ = await saga(action as? T)
                }
            }
            
//        case .takeLatest:
//            if let saga = effect.saga{
//                currentTasks[effect.identifier]?.cancel()
//                currentTasks[effect.identifier] = nil
//                currentTasks[effect.identifier] = Task.detached{
//                    let _ = await saga(effect.action)
//                    self.currentTasks[effect.identifier]?.cancel()
//                    self.currentTasks[effect.identifier] = nil
//                }
//            }
//
//        case .takeLeading:
//            if let saga = effect.saga{
//                if self.currentTasks[effect.identifier] != nil {
//                    return
//                }
//                currentTasks[effect.identifier] = Task.detached{
//                    let _ = await saga(effect.action)
//                    self.currentTasks[effect.identifier]?.cancel()
//                    self.currentTasks[effect.identifier] = nil
//                }
//            }
            
        default:
            break
        }
        
    }
    
    /**
     特定の action を監視して、イベントを実行する。主に take 向け。
     */
    func match(_ action:  any Action, receive: @escaping (_ action:  any Action) -> Void ){
        // 監視は一度限りで行い、検出後は破棄する
        // 破棄しないと、検出した action を対応にした場合、withCheckedContinuation で二重呼び出しにカウントされクラッシュする
//        var cancellable: AnyCancellable? = nil
//
//        cancellable =  subject.filter {
//            $0.isEqualTo(action)
//        }.sink { [weak self] in
//            self?.complete($0)
//            cancellable?.cancel()
//        } receiveValue: {
//            receive($0)
//            cancellable?.cancel()
//        }
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
