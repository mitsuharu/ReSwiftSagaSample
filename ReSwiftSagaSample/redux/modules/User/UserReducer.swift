//
//  UserReducer.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/16.
//

import Foundation

func userReducer(action: UserAction, state: UserState) -> UserState {
    
    switch action {
    case .requestUser(userID: let userID):
        return UserState(userID: userID, name: state.name)

    case .storeUserName(name: let name):
        return UserState(userID: state.userID, name: name)
        
    case .clear:
        return UserState(userID: nil, name: nil)
    }
}
