//
//  Saga.swift
//  ReSwiftSagaSample
//
//  Created by 江本 光晴 on 2023/05/30.
//

import ReSwift

func createSagaMiddleware<State>() -> Middleware<State> {
    return { dispatch, getState in
        return { next in
            return { action in
                if let action = action as? (any SagaAction) {
                    SagaMonitor.shared.send(action)
                }
                return next(action)
            }
        }
    }
}
