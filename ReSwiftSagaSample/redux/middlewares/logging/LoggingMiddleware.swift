//
//  LoggingMiddleware.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation
import ReSwift

let loggingMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            // perform middleware logic
            print(action)

            // call next middleware
            return next(action)
        }
    }
}
