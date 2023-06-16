//
//  CounterSaga.swift
//  ReSwiftSagaSample
//
//  Created by 江本 光晴 on 2023/06/03.
//

import Foundation
import ReSwift

let counterSaga: Saga<Action, Void> = { action  in
    
    
//    do{
//        try await Task.sleep(nanoseconds: UInt64(1) * 1_000_000_000)
//    }catch{
//
//    }

    takeEvery(Increase.self, saga: increaseSaga)
    takeEvery(Move.self, saga: moveSaga)
    
//
//    return 0
 

}



let increaseSaga: Saga = { (_ action: Action?) async in
    print("increaseSaga", action ?? "", "start")
    
    Task{
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
    print("increaseSaga", action ?? "", "end")
    

//
//    let aaaa = await take(CounterAction.decrease as (any SagaAction))
//    print("increaseSaga take:", aaaa )
}

let increaseSaga2: Saga = { (_ action: Action?) in
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        print("1秒後の処理 increaseSaga2")
    }
    print("increaseSaga2", action ?? "")
    
}

let moveSaga: Saga = { (_ action: Action?) in
  
    guard let move = action as? Move else {
        return
    }
  
    print("moveSaga move", move, move.count)
    

    
    print("moveSaga", action ?? "", action.self ?? "")
    
}

