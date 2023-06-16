//
//  AppState.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation

struct AppState {
    let counter: CounterState
    let user: UserState

    static func initialState() -> AppState {
        AppState(
            counter: CounterState.initialState(),
            user: UserState.initialState()
        )
    }
}
