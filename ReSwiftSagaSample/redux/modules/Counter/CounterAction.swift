//
//  CounterAction.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation
import ReSwift

protocol CounterAction: Action {}

struct Increase: CounterAction {}
struct decrease: CounterAction {}
struct Move: CounterAction {
    let count: Int
}
struct clear: CounterAction {}


//enum CounterAction: SagaAction {
//    case increase
//    case decrease
//    case move(count: Int)
//    case clear
//}
