//
//  UserAction.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/16.
//

import Foundation
import ReSwift

enum UserAction: Action {
    case requestUser(userID: String)
    case storeUserName(name: String)
    case clear
}

struct AAA: Action {}
struct BBB: Action {
    let userID: String
}
