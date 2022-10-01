//
//  AppReducer.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation
import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {

    let state = state ?? AppState.initialState()

    var nextCounter = state.counter
    if action is CounterAction {
        nextCounter = counterReducer(action: action as! CounterAction,
                                     state: state.counter)
    }
    
    return AppState(
        counter: nextCounter
    )
}
