//
//  CounterSaga.swift
//  ReSwiftSagaSample
//
//  Created by 江本 光晴 on 2023/06/03.
//

import Foundation
import ReSwift

let counterSaga: Saga = { (_ action: Action?) in
//    takeEvery(CounterAction.increase, effect: increaseSaga)
//    takeEvery(CounterAction.increase, effect: increaseSaga2)
    

    takeLatest(CounterAction.increase, effect: increaseSaga)
    takeLatest(CounterAction.increase, effect: increaseSaga2)
}

let increaseSaga: Saga = { (_ action: Action?) in
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        print("1秒後の処理 increaseSaga")
    }
    print("increaseSaga", action ?? "")
    
}

let increaseSaga2: Saga = { (_ action: Action?) in
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        print("1秒後の処理 increaseSaga2")
    }
    print("increaseSaga2", action ?? "")
    
}
