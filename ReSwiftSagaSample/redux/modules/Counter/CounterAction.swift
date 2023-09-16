//
//  CounterAction.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation
import ReSwiftSaga

protocol CounterAction: SagaAction {}

struct Increase: CounterAction {}
struct Decrease: CounterAction {}
struct Move: CounterAction { let count: Int }
struct Clear: CounterAction {}

