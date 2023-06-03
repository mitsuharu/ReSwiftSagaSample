//
//  Saga.swift
//  ReSwiftSagaSample
//
//  Created by 江本 光晴 on 2023/05/30.
//

import ReSwift
import Combine

protocol SagaAction: Action, Hashable {}

extension SagaAction {
    // プロトコルでは直接比較(==)できないための回避策
    func isEqualTo(_ arg: any SagaAction) -> Bool {
        return self.hashValue == arg.hashValue
    }
}

// TODO: 非同期関数にする
typealias Saga<T> = (_ action: (any SagaAction)?) -> T

final class SagaStream {
    
    let actionPublisher = PassthroughSubject<any SagaAction, Error>()
    
    // TODO: 類似管理をやめる
    var cancellables = Set<AnyCancellable>()
    var currentTasks: [String:AnyCancellable] = [:]
    
    func cancel() {
        cancellables.forEach { $0.cancel() }
        currentTasks.values.forEach { $0.cancel() }
    }
    
    // TODO: エラー時の処理を書く
    func complete(_ completion: Subscribers.Completion<Error>){
        switch completion {
        case .finished:
            print("finished successfully")
        case .failure(let error):
            assertionFailure("SagaStream#error \(error)")
        }
    }
    
    public static let shared = SagaStream()
}

func createSagaMiddleware<State>() -> Middleware<State> {
    let stream = SagaStream.shared
    return { dispatch, getState in
        return { next in
            return { action in
                stream.actionPublisher.send(action as! (any SagaAction))
                return next(action)
            }
        }
    }
}
