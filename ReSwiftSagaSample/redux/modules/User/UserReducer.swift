//
//  UserReducer.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/16.
//

import Foundation

func userReducer(action: UserAction, state: UserState) -> UserState {
    
    switch action {
    case let action as RequestUser:
        return UserState(userID: action.userID, name: state.name)
    
    case let action as StoreUserName:
        return UserState(userID: state.userID, name: action.name)
        
    case _ as ClearUser:
        return UserState(userID: nil, name: nil)
    
    default:
        return state
    }
    
}
