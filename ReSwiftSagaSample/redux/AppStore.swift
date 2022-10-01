//
//  AppStore.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation
import ReSwift

func makeAppStore() -> Store<AppState> {

    let store = Store<AppState>(
        reducer: appReducer,
        state: AppState.initialState()
    )

    return store
}
