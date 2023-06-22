//
//  Effects.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/17.
//

import Foundation

func put(_ action: SagaAction) {
    if let dispatch = Channel.shared.dispatch {
        Task.detached { @MainActor in
            dispatch(action)
        }
    }
}

func selector<State, T>(_ selector: (State) -> T) async throws -> T {
    if let getState = Channel.shared.getState,
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
        Channel.shared.take(actionType) { action in
            continuation.resume(returning: action)
        }
    }
}

func takeEvery( _ actionType: SagaAction.Type, saga: @escaping Saga<Any>) {
    Task.detached {
        while true {
            let action = await take(actionType)
            let _ = await saga(action)
        }
    }
}

func takeLatest( _ actionType: SagaAction.Type, saga: @escaping Saga<Any>) {
    let buffer = Buffer()
    Task.detached {
        while true {
            let action = await take(actionType)
            buffer.done()
            buffer.task = Task.detached{
                defer { buffer.done() }
                let _ = await saga(action)
            }
        }
    }
}

func takeLeading( _ actionType: SagaAction.Type, saga: @escaping Saga<Any>) {
    let buffer = Buffer()
    Task.detached {
        while true {
            let action = await take(actionType)
            if (buffer.task != nil){
                continue
            }
            buffer.task = Task.detached {
                defer { buffer.done() }
                let _ = await saga(action)
            }
        }
    }
}
