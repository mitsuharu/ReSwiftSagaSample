//
//  CounterViewModel.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation
import ReSwift

final class CounterViewModel: ObservableObject, StoreSubscriber {
    @Published private(set) var count: Int = 0

    init() {
        appStore.subscribe(self) {
            $0.select { selectCount(store: $0) }
        }
    }

    deinit {
        appStore.unsubscribe(self)
    }

    internal func newState(state: Int) {
        self.count = state
    }
    
    public func increase() {
        appStore.dispatch(Increase())
//        appStore.dispatch(BBB(userID: "1234"))
    }
    
    public func decrease() {
     //   appStore.dispatch(CounterAction.decrease)
    }
    
    public func move(count: Int) {
        appStore.dispatch(Move(count: count))
    }

    public func clear() {
//appStore.dispatch(CounterAction.clear)
    }
}
