//
//  Buffer.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/22.
//

import Foundation

/**
 takeLeading, takeLatest 向けに task を管理する
 */
class Buffer {
    var task: Task<(), Never>? = nil
    
    func done(){
        self.task?.cancel()
        self.task = nil
    }
}
