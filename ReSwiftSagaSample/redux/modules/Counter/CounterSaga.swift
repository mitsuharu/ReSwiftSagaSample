//
//  CounterSaga.swift
//  ReSwiftSagaSample
//
//  Created by 江本 光晴 on 2023/06/03.
//

import Foundation
import ReSwift

let counterSaga: Saga = { action  in
    
    
//    do{
//        try await Task.sleep(nanoseconds: UInt64(1) * 1_000_000_000)
//    }catch{
//
//    }

    takeEvery(Increase.self, saga: increaseSaga)
//    takeEvery(Move.self, saga: moveSaga)
    
//
//    return 0
 

}



let increaseSaga: Saga = { action async in
    

    guard let action = action as? Increase else {
        return
    }
    
    print("increaseSaga", action )
    
//    Task{
//        try? await Task.sleep(nanoseconds: 1_000_000_000)
//    }
//    print("increaseSaga", action ?? "", "end")
    

//
    print("increaseSaga take: wait" )
    let aaaa = await take(Decrease.self)
    print("increaseSaga take:", aaaa )
}

//let increaseSaga2: Saga = { (_ action: Action?) in
//
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//        print("1秒後の処理 increaseSaga2")
//    }
//    print("increaseSaga2", action ?? "")
//
//}
//
//let moveSaga: Saga = { (_ action: Action?) in
//
//    guard let move = action as? Move else {
//        return
//    }
//
//    print("moveSaga move", move, move.count)
//
//
//
//    print("moveSaga", action ?? "", action.self ?? "")
//
//}
//
