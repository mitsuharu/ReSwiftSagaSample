//
//  Saga.swift
//  ReSwiftSagaSample
//
//  Created by 江本 光晴 on 2023/05/30.
//

import ReSwift

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
 Saga 向けの middleware
 */
func createSagaMiddleware<State>() -> Middleware<State> {
    return { dispatch, getState in
        
        SagaMonitor.shared.dispatch = dispatch
        SagaMonitor.shared.getState = getState
        
        return { next in
            return { action in
                if let action = action as? SagaAction {
                    SagaMonitor.shared.send(action)
                }
                return next(action)
            }
        }
    }
}
