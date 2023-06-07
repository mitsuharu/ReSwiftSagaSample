//
//  SagaEffect.swift
//  ReSwiftSagaSample
//
//  Created by 江本 光晴 on 2023/05/30.
//

import ReSwift
import Combine
import Foundation

//protocol SagaEffect {
////    func put(_ action: any SagaAction)
////    func call<T>(_ effect: @escaping Saga<T>, _ arg: ( any SagaAction))
////    func fork<T>(_ effect: @escaping Saga<T>, _ arg: ( any SagaAction))
//    func take(_ action: any SagaAction) async -> any SagaAction
//    func takeEvery<T>( _ action:  any SagaAction, effect: @escaping Saga<T>)
////    func takeLatest<T>( _ action:  any SagaAction, effect: @escaping Saga<T>)
////    func takeLeading<T>( _ action:  any SagaAction, effect: @escaping Saga<T>)
//}




extension SagaProvider{
    
    

}




func put(_ action: any SagaAction){
    SagaProvider.shared.send(action)
}

func call<T>(_ effect: @escaping Saga<T>, _ arg: ( any SagaAction)? = nil){
    Task {
        return await effect(arg)
    }
}

func fork<T>(_ effect: @escaping Saga<T>, _ arg: ( any SagaAction)? = nil){
    Task.detached {
        await effect(arg)
    }
}

//private var activeContinuation: CheckedContinuation<any SagaAction, Never>? = nil

// この実装だと、2回目のtakeでクラッシュする。
// resumeが複数呼び出しにカウントされる
func take(_ action: any SagaAction) async -> any SagaAction {
    return await withCheckedContinuation { continuation in
        SagaProvider.shared.match(action) { action in
            continuation.resume(returning: action)
        }
    }
}

func takeEvery<T>( _ action:  any SagaAction, effect: @escaping Saga<T>)  {
    SagaProvider.shared.addEffect(SagaEffect(pattern: .takeEvery, action: action, saga: effect))
    
//    SagaProvider.shared.match(action) { action in
//        Task.detached {
//            let _ = await effect(action)
//        }
//    }
}


func takeLatest<T>( _ action:  any SagaAction, effect: @escaping Saga<T>)  {
    SagaProvider.shared.addEffect(SagaEffect(pattern: .takeLatest, action: action, saga: effect))
}

func takeLeading<T>( _ action:  any SagaAction, effect: @escaping Saga<T>)  {
    SagaProvider.shared.addEffect(SagaEffect(pattern: .takeLeading, action: action, saga: effect))
}
