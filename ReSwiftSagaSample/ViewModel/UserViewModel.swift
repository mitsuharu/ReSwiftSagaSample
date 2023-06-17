//
//  UserViewModel.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/17.
//

import Foundation
import ReSwift

final class UserViewModel: ObservableObject, StoreSubscriber {
    @Published private(set) var name: String = ""

    init() {
        appStore.subscribe(self) {
            $0.select { selectUserName(store: $0) }
        }
    }

    deinit {
        appStore.unsubscribe(self)
    }

    internal func newState(state: String) {
        self.name = state
    }
    
    public func requestUser() {
        appStore.dispatch(RequestUser(userID: "1234"))
    }
    
    public func clearUser() {
        appStore.dispatch(ClearUser())
    }
    
}
