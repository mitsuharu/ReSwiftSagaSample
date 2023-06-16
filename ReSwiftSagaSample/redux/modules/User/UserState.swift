//
//  UserState.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/16.
//

import Foundation

struct UserState {
    let userID: String?
    let name: String?

    static func initialState() -> UserState {
        UserState(userID: nil, name: nil)
    }
}
