//
//  CounterSelectors.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation

func selectCount(store: AppState) -> Int {
    store.counter.count
}
