//
//  SagaEffect.swift
//  ReSwiftSagaSample
//
//  Created by 江本 光晴 on 2023/05/30.
//

import ReSwift
import Combine

func put(_ action: any SagaAction){
    SagaMonitor.shared.send(action)
}

func call<T>(_ effect: @escaping Saga<T>, _ arg: ( any SagaAction)? = nil) async -> T{
    return await effect(arg)
}

func fork<T>(_ effect: @escaping Saga<T>, _ arg: ( any SagaAction)? = nil){
    Task.detached {
        await effect(arg)
    }
}

func take(_ action: any SagaAction) async -> any SagaAction {
    return await withCheckedContinuation { continuation in
        SagaMonitor.shared.match(action) { action in
            continuation.resume(returning: action)
        }
    }
}

func takeEvery<T>( _ action:  any SagaAction, saga: @escaping Saga<T>)  {
    SagaMonitor.shared.addEffect(SagaEffect(pattern: .takeEvery, action: action, saga: saga))
}


func takeLatest<T>( _ action:  any SagaAction, saga: @escaping Saga<T>)  {
    SagaMonitor.shared.addEffect(SagaEffect(pattern: .takeLatest, action: action, saga: saga))
}

func takeLeading<T>( _ action:  any SagaAction, saga: @escaping Saga<T>)  {
    SagaMonitor.shared.addEffect(SagaEffect(pattern: .takeLeading, action: action, saga: saga))
}
