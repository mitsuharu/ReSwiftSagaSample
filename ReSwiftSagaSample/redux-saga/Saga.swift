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
                if let action = action as? SagaAction {
                    SagaMonitor.shared.send(action)
                }
                return next(action)
            }
        }
    }
}

func put(_ action: SagaAction){
    SagaMonitor.shared.send(action)
}

@discardableResult
func call(_ effect: @escaping Saga<Any>, _ arg: SagaAction) async -> Any {
    return await effect(arg)
}

@discardableResult
func call(_ effect: @escaping Saga<Any>) async -> Any {
    let action = SagaAction()
    return await effect(action)
}

func fork(_ effect: @escaping Saga<Any>, _ arg: SagaAction) async -> Void {
    Task.detached{
        let _ = await effect(arg)
    }
}

func fork(_ effect: @escaping Saga<Any>) async -> Void {
    Task.detached{
        let action = SagaAction()
        let _ = await effect(action)
    }
}

@discardableResult
func take(_ actionType: SagaAction.Type) async -> SagaAction {
    return await withCheckedContinuation { continuation in
        SagaMonitor.shared.match(actionType) { action in
            continuation.resume(returning: action)
        }
    }
}

func takeEvery( _ action: SagaAction.Type, saga: @escaping Saga<Any>)  {
    let effect = SagaStore(pattern: .takeEvery, type: action.self, saga: saga)
    SagaMonitor.shared.addStore(effect)
}

func takeLatest( _ action: SagaAction.Type, saga: @escaping Saga<Any>)  {
    let effect = SagaStore(pattern: .takeLatest, type: action.self, saga: saga)
    SagaMonitor.shared.addStore(effect)
}

func takeLeading( _ action: SagaAction.Type, saga: @escaping Saga<Any>)  {
    let effect = SagaStore(pattern: .takeLeading, type: action.self, saga: saga)
    SagaMonitor.shared.addStore(effect)
}

