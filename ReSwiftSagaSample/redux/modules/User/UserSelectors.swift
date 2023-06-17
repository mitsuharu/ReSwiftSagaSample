//
//  UserSelectors.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/16.
//

import Foundation

func selectUserId(store: AppState) -> String {
    store.user.userID ?? ""
}

func selectUserName(store: AppState) -> String {
    store.user.name ?? ""
}
