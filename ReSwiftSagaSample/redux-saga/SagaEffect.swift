//
//  SagaEffect.swift
//  ReSwiftSagaSample
//
//  Created by 江本 光晴 on 2023/05/30.
//

import ReSwift
import Combine
import Foundation

protocol SagaEffect {
    func put(_ action: any SagaAction)
    func call<T>(_ effect: @escaping Saga<T>, _ arg: ( any SagaAction))
    func fork<T>(_ effect: @escaping Saga<T>, _ arg: ( any SagaAction))
    func take(_ action: any SagaAction) async -> any SagaAction
    func takeEvery<T>( _ action:  any SagaAction, effect: @escaping Saga<T>)
    func takeLatest<T>( _ action:  any SagaAction, effect: @escaping Saga<T>)
    func takeLeading<T>( _ action:  any SagaAction, effect: @escaping Saga<T>)
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
    SagaProvider.shared.match(action) { action in
        Task.detached {
            let _ = await effect(action)
        }
    }
}

func takeEvery2<T>( _ action:  any SagaAction, effect: @escaping Saga<T>)  {
    Task.detached {
        while true {
            let result = await take(action) // ここで2回目扱いでクラッシュする
            if result.isEqualTo(action){
                let _ = await effect(result)
            }
        }
    }
}

func takeLatest<T>( _ action:  any SagaAction, effect: @escaping Saga<T>)  {
    Task.detached {
        
        print("takeLatest")
        var task: Task<Void, Never>? = nil
        
        while true {
            let result = await take(action)
            
            print("takeLatest result:", result, "task:", task != nil)
            
            if result.isEqualTo(action){
                task?.cancel()
                task = Task.detached {
                    let _ = await effect(result)
                }
                print("takeLatest return")
                return
            }
        }
    }
}

//func takeLatest<T>( _ action:  any SagaAction, effect: @escaping Saga<T>)  {
//    let stream = SagaProvider.shared
//        
//
//    do{
//        let adderData = try? JSONEncoder().encode(effect)
//    }catch{
//        
//    }
//    // TODO: 関数もハッシュキーに含めたい
//    let hashKey = "takeLatest-" + action.hashValue.description
//
//    stream.currentTasks[hashKey]?.cancel()
//    stream.currentTasks[hashKey] = stream.actionPublisher.sink {
//        stream.complete($0)
//    } receiveValue: {
//        // プロトコルでは直接比較(==)できないための回避
//        if $0.isEqualTo(action){
//            let _ = effect($0)
//        }
//    }
//}

//func takeLeading<T>( _ action:  any SagaAction, effect: @escaping Saga<T>)  {
//    let stream = SagaProvider.shared
//    
//    // TODO: 関数もハッシュキーに含めたい
//    let hashKey = "takeLeading-" + action.hashValue.description
//
//    if stream.currentTasks[hashKey] != nil{
//        return
//    }
//    
//    stream.currentTasks[hashKey] = stream.actionPublisher.sink {
//        stream.complete($0)
//    } receiveValue: {
//        // プロトコルでは直接比較(==)できないための回避
//        if $0.isEqualTo(action){
//            let _ = effect($0)
//        }
//    }
//}
