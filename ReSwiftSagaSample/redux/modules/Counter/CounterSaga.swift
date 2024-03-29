//
//  CounterSaga.swift
//  ReSwiftSagaSample
//
//  Created by 江本 光晴 on 2023/06/03.
//

import Foundation
import ReSwiftSaga

let counterSaga: Saga = { _ in
    takeEvery(Increase.self, saga: increaseSaga)
    takeEvery(Increase.self, saga: subIncreaseSaga)
    takeLatest(Decrease.self, saga: decreaseSaga)
    takeLeading(Move.self, saga: moveSaga)
}

private let increaseSaga: Saga = { action async in
    guard let action = action as? Increase else {
        return
    }
    print("increaseSaga", action )
}

private let subIncreaseSaga: Saga = { action async in
    guard let action = action as? Increase else {
        return
    }
    print("subIncreaseSaga", action )
}

private let decreaseSaga: Saga = { action async in
    guard let action = action as? Decrease else {
        return
    }
    print("decreaseSaga#start", action )
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    print("decreaseSaga#end", action )
}

private let moveSaga: Saga = { action async in
    guard let move = action as? Move else {
        return
    }
    print("moveSaga#start move", move, move.count)
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    print("moveSaga#end move", move, move.count)
}

