//
//  AppStore.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation
import ReSwift

func makeAppStore() -> Store<AppState> {
    
    let sagaMiddleware: Middleware<AppState> = createSagaMiddleware()
    
    let store = Store<AppState>(
        reducer: appReducer,
        state: AppState.initialState(),
        middleware: [sagaMiddleware]
    )

    Task.detached {
        await fork(appSage)
    }
    
    return store
}


extension Store {
    
    public func dispatch(onMain action: Action) {
        onMainThread { self.dispatch(action) }
    }

    private func onMainThread(_ handler: @escaping () -> Void) {
        if Thread.isMainThread {
            handler()
        } else {
            Task.detached { @MainActor in
                handler()
            }
        }
    }
}
