//
//  CounterAction.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation

class CounterAction: SagaAction {}

class Increase: CounterAction {}
class Decrease: CounterAction {}
class Move: CounterAction {
    let count: Int
    init(count: Int) {
        self.count = count
    }
}
class Clear: CounterAction {}

