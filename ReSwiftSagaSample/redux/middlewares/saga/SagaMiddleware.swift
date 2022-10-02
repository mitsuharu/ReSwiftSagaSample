//
//  SagaMiddleware.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation
import ReSwift
import Combine


/*
 public typealias DispatchFunction = (Action) -> Void
 public typealias Middleware<State> = (@escaping DispatchFunction, @escaping () -> State?)
     -> (@escaping DispatchFunction) -> DispatchFunction
 */

let sagaMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            // perform middleware logic
            print("saga", action)
            
            let associated = action.associated
//            print("associated.label", associated.label)
//            print("associated.value", associated.value)
//            print("associated.values", associated.values)
            

            NotificationCenter.default.post(name: Notification.Name(associated.label),
                                            object: associated.values)
  
            // call next middleware
            return next(action)
        }
    }
}

public extension ReSwift.Action {
    // https://stackoverflow.com/a/54455124
    var associated: (label: String, value: Any?, values: Dictionary<String,Any>?) {
        get {
            let mirror = Mirror(reflecting: self)
            if mirror.displayStyle == .enum {
                if let associated = mirror.children.first {
                    let values = Mirror(reflecting: associated.value).children
                    var dict = Dictionary<String,Any>()
                    for i in values {
                        dict[i.label ?? ""] = i.value
                    }
                    return (associated.label!, associated.value, dict)
                }
                print("WARNING: Enum option of \(self) does not have an associated value")
                return ("\(self)", nil, nil)
            }
            print("WARNING: You can only extend an enum with the EnumExtension")
            return ("\(self)", nil, nil)
        }
    }
}
