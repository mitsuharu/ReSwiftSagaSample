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
    var nextUser = state.user

    switch action {
    case let action as CounterAction:
        nextCounter = counterReducer(action: action, state: state.counter)
    
    case let action as UserAction:
        nextUser = userReducer(action: action, state: state.user)
    
    default:
        break
    }
    
    return AppState(
        counter: nextCounter,
        user: nextUser
    )
}
