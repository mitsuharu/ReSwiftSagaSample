//
//  UserSaga.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/16.
//

import Foundation

let userSaga: Saga = { _ in
    
//    takeEvery(CounterAction.increase, effect: increaseSaga)
//
//    takeEvery(CounterAction.clear, effect: increaseSaga)
    
//    SagaMonitor.shared.takeEvery(CounterAction.increase, effect: increaseSaga2)
    

    
//    takeLatest(BBB.self as! (any SagaAction), saga: requestUserSaga)
//    takeLatest(CounterAction.increase, effect: increaseSaga2)
}

let requestUserSaga: Saga = { action async in
    guard let action = action as? RequestUser else {
        return
    }
    
    print("requestUserSaga#start", action)
    

    try? await Task.sleep(nanoseconds: 1_000_000_000)
    
    
    print("requestUserSaga#end", action)
    
//    Task{
//        try? await Task.sleep(nanoseconds: 1_000_000_000)
//    }
//    print("increaseSaga", action ?? "", "end")
//
//
//    let aaaa = await take(CounterAction.decrease as (any SagaAction))
//    print("increaseSaga take:", aaaa )
}
