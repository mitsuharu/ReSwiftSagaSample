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
    if action is (any CounterAction) {
        nextCounter = counterReducer(action: action as! (any CounterAction),
                                     state: state.counter)
    }
    
    var nextUser = state.user
    if action is UserAction {
        nextUser = userReducer(action: action as! UserAction,
                               state: state.user)
    }
    
    return AppState(
        counter: nextCounter,
        user: nextUser
    )
}
