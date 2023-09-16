//
//  UserAction.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/16.
//

import Foundation
import ReSwiftSaga

protocol UserAction: SagaAction {}

struct RequestUser: UserAction {
    let userID: String
}

struct StoreUserName: UserAction {
    let name: String
}

struct ClearUser: UserAction {
}

