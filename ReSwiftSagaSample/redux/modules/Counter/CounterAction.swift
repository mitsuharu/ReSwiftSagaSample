//
//  CounterAction.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation
import ReSwift

struct CounterParams {
    var count: Int
}

enum CounterAction: Action {
    case increase
    case decrease
    case move(count: Int)
    case clear
//    case bbb(_ param: CounterParams)
}



//let c = CounterAction.bbb( CounterParams(count:1))
