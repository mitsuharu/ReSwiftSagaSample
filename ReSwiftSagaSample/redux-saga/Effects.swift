//
//  Effects.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/17.
//

import Foundation

func put(_ action: SagaAction) {
    if let dispatch = SagaMonitor.shared.dispatch {
        Task.detached { @MainActor in
            dispatch(action)
        }
    }
}

func selector<State, T>(_ selector: (State) -> T) async throws -> T {
    if let getState = SagaMonitor.shared.getState,
       let state = getState() as? State  {
      return selector(state)
    }
    throw SagaError.invalid
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

func takeEvery( _ action: SagaAction.Type, saga: @escaping Saga<Any>) {
    let effect = SagaStore(pattern: .takeEvery, type: action.self, saga: saga)
    SagaMonitor.shared.addStore(effect)
}

func takeLatest( _ action: SagaAction.Type, saga: @escaping Saga<Any>) {
    let effect = SagaStore(pattern: .takeLatest, type: action.self, saga: saga)
    SagaMonitor.shared.addStore(effect)
}

func takeLeading( _ action: SagaAction.Type, saga: @escaping Saga<Any>) {
    let effect = SagaStore(pattern: .takeLeading, type: action.self, saga: saga)
    SagaMonitor.shared.addStore(effect)
}

