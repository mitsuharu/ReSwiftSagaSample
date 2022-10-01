//
//  CounterReducer.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation
import ReSwift

func counterReducer(action: Action, state: CounterState?) -> CounterState {
    
    let state = state ?? CounterState.initialState()
    guard let action = action as? CounterAction else {
        return state
    }
    
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
