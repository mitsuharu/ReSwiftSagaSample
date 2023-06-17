//
//  CounterState.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation

struct CounterState {
    let count: Int

    static func initialState() -> CounterState {
        CounterState(count: 0)
    }
}
