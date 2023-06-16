//
//  SagaEffect.swift
//  ReSwiftSagaSample
//
//  Created by 江本 光晴 on 2023/05/30.
//

import ReSwift
import Combine

func put(_ action: any Action){
    sagaMonitor.send(action)
}

func call<T, K>(_ effect: @escaping Saga<T, K>, _ arg: T) async ->K{
    return await effect(arg)
}

func call<T, K>(_ effect: @escaping Saga<T, K>) async -> K{
    let action = ActionStruct()
    return await effect(action as! T)
}

//func fork<T>(_ effect: @escaping Saga<T>, _ arg: ( any Action)? = nil){
//    Task.detached {
//        await effect(arg)
//    }
//}

func take(_ action: any Action) async -> any Action {
    return await withCheckedContinuation { continuation in
        sagaMonitor.match(action) { action in
            continuation.resume(returning: action)
        }
    }
}

func takeEvery( _ action: Action.Type, saga: @escaping Saga<any Action, Any>)  {
    
    print("takeEvery, action:", action, "saga:", saga)
    
    let effect = SagaEffect(pattern: .takeEvery, type: action.self, saga: saga)
    sagaMonitor.addEffect(effect)
}


//func takeLatest<T>( _ action:  any Action, saga: @escaping Saga<T>)  {
//
//  //  SagaMonitor.shared.addEffect(SagaEffect(pattern: .takeLatest, action: action, saga: saga))
//}
//
//func takeLeading<T>( _ action:  any Action, saga: @escaping Saga<T>)  {
//  //  SagaMonitor.shared.addEffect(SagaEffect(pattern: .takeLeading, action: action, saga: saga))
//}
