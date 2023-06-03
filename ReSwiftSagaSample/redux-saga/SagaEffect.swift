//
//  SagaEffect.swift
//  ReSwiftSagaSample
//
//  Created by 江本 光晴 on 2023/05/30.
//

import ReSwift
import Combine

func put(_ action:  any SagaAction){
    let stream = SagaStream.shared
    stream.actionPublisher.send(action)
}

func call<T>(_ effect: @escaping Saga<T>, _ arg: ( any SagaAction)? = nil){
    Task{
        return effect(arg)
    }
}

func fork<T>(_ effect: @escaping Saga<T>, _ arg: ( any SagaAction)? = nil){
    Task.detached {
        effect(arg)
    }
}

func takeEvery<T>( _ action:  any SagaAction, effect: @escaping Saga<T>)  {
    let stream = SagaStream.shared
    stream.actionPublisher.sink {
        stream.complete($0)
    } receiveValue: {
        // プロトコルでは直接比較(==)できないための回避
        if $0.isEqualTo(action){
            let _ = effect($0)
        }
    }.store(in: &stream.cancellables)
}

func takeLatest<T>( _ action:  any SagaAction, effect: @escaping Saga<T>)  {
    let stream = SagaStream.shared
    let hashKey = "takeLatest-" + action.hashValue.description

    stream.currentTasks[hashKey]?.cancel()
    stream.currentTasks[hashKey] = stream.actionPublisher.sink {
        stream.complete($0)
    } receiveValue: {
        // プロトコルでは直接比較(==)できないための回避
        if $0.isEqualTo(action){
            let _ = effect($0)
        }
    }
}

func takeLeading<T>( _ action:  any SagaAction, effect: @escaping Saga<T>)  {
    let stream = SagaStream.shared
    let hashKey = "takeLeading-" + action.hashValue.description

    if stream.currentTasks[hashKey] != nil{
        return
    }
    
    stream.currentTasks[hashKey] = stream.actionPublisher.sink {
        stream.complete($0)
    } receiveValue: {
        // プロトコルでは直接比較(==)できないための回避
        if $0.isEqualTo(action){
            let _ = effect($0)
        }
    }
}
