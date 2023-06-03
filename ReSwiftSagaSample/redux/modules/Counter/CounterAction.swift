//
//  CounterAction.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation
import ReSwift

enum CounterAction: SagaAction {
    case increase
    case decrease
    case move(count: Int)
    case clear
}
