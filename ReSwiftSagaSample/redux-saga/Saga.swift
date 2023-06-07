//
//  Saga.swift
//  ReSwiftSagaSample
//
//  Created by 江本 光晴 on 2023/05/30.
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
    
    func hashKey() -> String{
        return String(self.hashValue)
    }
}

/**
 Sagaで実行する関数の型
 */
typealias Saga<T> = (_ action: (any SagaAction)?) async -> T

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

// Provider
final class SagaProvider {
    
    public static let shared = SagaProvider()
    
    private let subject = PassthroughSubject<any SagaAction, Error>()
    private var effects = Set<SagaEffect<Any>>()
    
    private var cancellables = Set<AnyCancellable>()
    private var currentTasks = [String:Task<(), Never>]()
    
    var activeContinuation: CheckedContinuation<any SagaAction, Never>? = nil
    
    /**
     action を発行する
     */
    func send(_ action: any SagaAction){
        subject.send(action)
    }
    
    func addEffect(_ effect:SagaEffect<Any>){
        effects.insert(effect)
    }
    
    init() {
        observe()
    }
    
    func observe(){
        subject.sink { [weak self] in
            self?.complete($0)
        } receiveValue: { [weak self] action in
            
            print("observe action:", action)

            self?.effects.filter { $0.action?.isEqualTo(action) == true }.forEach({ effect in
                self?.execute(effect)
            })
        }.store(in: &self.cancellables)
    }
    
    func execute(_ effect: SagaEffect<Any>) {
        print("execute effect:", effect)
        if effect.pattern == .takeEvery, let saga = effect.saga{
            Task.detached{
                let _ = await saga(effect.action)
            }
        }
        if effect.pattern == .takeLatest, let saga = effect.saga{
            print("currentTasks[effect.identifier]", currentTasks[effect.identifier])
            currentTasks[effect.identifier]?.cancel()
            self.currentTasks[effect.identifier] = nil
            currentTasks[effect.identifier] = Task.detached{
                let _ = await saga(effect.action)
                print("taleLatest done")
                self.currentTasks[effect.identifier]?.cancel()
                self.currentTasks[effect.identifier] = nil
            }
        }
        if effect.pattern == .takeLeading, let saga = effect.saga{
            if(self.currentTasks[effect.identifier] != nil){
                return
            }
            currentTasks[effect.identifier] = Task.detached{
                let _ = await saga(effect.action)
                self.currentTasks[effect.identifier]?.cancel()
                self.currentTasks[effect.identifier] = nil
            }
        }
    }
    
    
    
    /**
     特定の action を監視して、イベントを実行する
     */
    func match(_ action: any SagaAction, receive: @escaping (_ action: any SagaAction) -> Void ){
        print("match action:", action)
        
        subject.filter {
            print("match filter $0:", $0, "action:", action)
            return $0.isEqualTo(action)
        }.sink { [weak self] in
            self?.complete($0)
        } receiveValue: { [weak self] in
            // プロトコルでは直接比較(==)できないための回避
            if $0.isEqualTo(action){
                receive(action)
            }
            print("match $0:", $0, "action:", action, "receiveValue/cancellables:", self?.cancellables.count)
        }.store(in: &cancellables)
        
        print("match action:", action, "cancellables:", cancellables.count)
    }
    
    func cancel() {
        cancellables.forEach { $0.cancel() }
        currentTasks.values.forEach { $0.cancel() }
    }
    
    /**
     エラー時の処理
     @TODO: エラーを投げるかは検討
     */
    func complete(_ completion: Subscribers.Completion<Error>){
        switch completion {
        case .finished:
            print("SagaProvider#finished")
        case .failure(let error):
            assertionFailure("SagaProvider#failure \(error)")
        }
    }
}

func createSagaMiddleware<State>() -> Middleware<State> {
    return { dispatch, getState in
        return { next in
            return { action in
                if let action = action as? (any SagaAction) {
                    SagaProvider.shared.send(action)
                }
                return next(action)
            }
        }
    }
}
