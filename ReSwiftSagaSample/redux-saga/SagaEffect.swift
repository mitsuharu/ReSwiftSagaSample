//
//  SagaEffect.swift
//  ReSwiftSagaSample
//
//  Created by 江本 光晴 on 2023/05/30.
//

import ReSwift
import Combine

func put(_ action: SagaAction){
    SagaMonitor.shared.send(action)
}

@discardableResult
func call(_ effect: @escaping Saga<SagaAction, Any>, _ arg: SagaAction) async -> Any {
    return await effect(arg)
}

@discardableResult
func call(_ effect: @escaping Saga<SagaAction, Any>) async -> Any {
    let action = SagaAction()
    return await effect(action)
}

func fork(_ effect: @escaping Saga<SagaAction, Any>, _ arg: SagaAction) async -> Void {
    Task.detached{
        let _ = await effect(arg)
    }
}

func fork(_ effect: @escaping Saga<SagaAction, Any>) async -> Void {
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

func takeEvery( _ action: SagaAction.Type, saga: @escaping Saga<SagaAction, Any>)  {
    let effect = SagaEffect(pattern: .takeEvery, type: action.self, saga: saga)
    SagaMonitor.shared.addEffect(effect)
}

func takeLatest( _ action: SagaAction.Type, saga: @escaping Saga<SagaAction, Any>)  {
    let effect = SagaEffect(pattern: .takeLatest, type: action.self, saga: saga)
    SagaMonitor.shared.addEffect(effect)
}

func takeLeading( _ action: SagaAction.Type, saga: @escaping Saga<SagaAction, Any>)  {
    let effect = SagaEffect(pattern: .takeLeading, type: action.self, saga: saga)
    SagaMonitor.shared.addEffect(effect)
}
