//
//  AppSaga.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/23.
//

import Foundation
import ReSwiftSaga

let appSage: Saga = { _ async in
    do {
        try await fork(counterSaga)
        try await fork(userSaga)
    } catch {
        print(error)
    }
}
