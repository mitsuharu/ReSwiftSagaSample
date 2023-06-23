//
//  AppSaga.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/23.
//

import Foundation

let appSage: Saga = { _ async in
    await fork(counterSaga)
    await fork(userSaga)
}
