//
//  UserSaga.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/16.
//

import Foundation
import ReSwift


//let userSaga: Saga = { (_ action: (any Action)?) in
//    
////    takeEvery(CounterAction.increase, effect: increaseSaga)
////
////    takeEvery(CounterAction.clear, effect: increaseSaga)
//    
////    SagaMonitor.shared.takeEvery(CounterAction.increase, effect: increaseSaga2)
//    
//
//    
////    takeLatest(BBB.self as! (any SagaAction), saga: requestUserSaga)
////    takeLatest(CounterAction.increase, effect: increaseSaga2)
//}
//
//let requestUserSaga: Saga = { (_ action: (any Action)?) async in
//    
//    
//    
//    
//    print("requestUserSaga", action ?? "", "start")
//    
//    if action is BBB.Type {
//        print("requestUserSaga action is BBB.Type" )
//    }
//    
////    Task{
////        try? await Task.sleep(nanoseconds: 1_000_000_000)
////    }
////    print("increaseSaga", action ?? "", "end")
////
////
////    let aaaa = await take(CounterAction.decrease as (any SagaAction))
////    print("increaseSaga take:", aaaa )
//}
