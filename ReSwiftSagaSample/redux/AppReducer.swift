//
//  AppReducer.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation
import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {

    guard let state else{
        return AppState.initialState()
    }

    return AppState(
        counter: counterReducer(action: action,
                                state: state.counter)
    )
}
