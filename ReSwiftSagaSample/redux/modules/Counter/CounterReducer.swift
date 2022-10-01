//
//  CounterReducer.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation

func counterReducer(action: CounterAction, state: CounterState) -> CounterState {
    
    switch action {
    case .increase:
        return CounterState(count: state.count + 1)

    case .decrease:
        return CounterState(count: state.count - 1)
        
    case .move(count: let count):
        return CounterState(count: count)
    
    case .clear:
        return CounterState.initialState()

    }
}
