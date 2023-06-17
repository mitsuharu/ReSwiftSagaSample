//
//  SagaStore.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/17.
//

import Foundation

/**
 構造体 SagaStore でサポートする副作用
 */
enum SagaPattern {
    case take
    case takeEvery
    case takeLeading
    case takeLatest
}

/**
 Saga でサポートするパターンを格納しておく Store
 */
struct SagaStore<T>: Hashable {
    
    let identifier = UUID().uuidString
        
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    static func == (lhs: SagaStore<T>, rhs: SagaStore<T>) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    let pattern: SagaPattern
    let type: SagaAction.Type
    let saga: Saga<T>
}
