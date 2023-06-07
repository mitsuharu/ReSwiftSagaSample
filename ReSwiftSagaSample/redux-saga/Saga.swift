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

enum TakePattern {
    case every
    case leading
    case latest
}

// Provider
final class SagaProvider {
    
    public static let shared = SagaProvider()
    
    private let subject = PassthroughSubject<any SagaAction, Error>()
    
    // TODO: 類似なので管理をやめる、どれかにする
    private var cancellables = Set<AnyCancellable>()
    private var currentTasks: [String:AnyCancellable] = [:]
    
    /**
     action を発行する
     */
    func send(_ action: any SagaAction){
        subject.send(action)
    }
    
    /**
     特定の action を監視して、イベントを実行する
     */
    func match(_ action: any SagaAction, receive: @escaping (_ action: any SagaAction) -> Void ){
        subject.sink { [weak self] in
            self?.complete($0)
        } receiveValue: {
            // プロトコルでは直接比較(==)できないための回避
            if $0.isEqualTo(action){
                receive(action)
            }
        }.store(in: &cancellables)
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
