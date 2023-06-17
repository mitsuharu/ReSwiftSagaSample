//
//  CounterSaga.swift
//  ReSwiftSagaSample
//
//  Created by 江本 光晴 on 2023/06/03.
//

import Foundation
import ReSwift

let counterSaga: Saga = { _ in
    takeEvery(Increase.self, saga: increaseSaga)
    takeLatest(Decrease.self, saga: decreaseSaga)
    takeEvery(Move.self, saga: moveSaga)
}

private let increaseSaga: Saga = { action async in
    guard let action = action as? Increase else {
        return
    }
    
    print("increaseSaga#start", action )
    

//    print("increaseSaga take: wait" )
//    let decrease = await take(Decrease.self)
//    print("increaseSaga take: ", action, "take:", decrease)
    
//    put(Move(count: 200))
    
 //   print("increaseSaga#end", action, "take:", decrease)
}

private let decreaseSaga: Saga = { action async in
    guard let action = action as? Decrease else {
        return
    }
    print("decreaseSaga#start", action )

    try? await Task.sleep(nanoseconds: 1_000_000_000)
    print("decreaseSaga#end", action )

}

private let moveSaga: Saga = { (_ action: Action?) in
    guard let move = action as? Move else {
        return
    }

    print("moveSaga#start move", move, move.count)

}

