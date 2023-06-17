//
//  UserAction.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/16.
//

import Foundation

class UserAction: SagaAction {}

class RequestUser: UserAction {
    let userID: String
    init(userID: String) {
        self.userID = userID
    }
}

class StoreUserName: UserAction {
    let name: String
    init(name: String) {
        self.name = name
    }
}

class ClearUser: UserAction {
    
}

