//
//  TakeEvery.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import Foundation
import ReSwift
import Combine

class TakeEvery{
    
    let action: Action
    var iterator: any IteratorProtocol

    
    init(action: Action, iterator: any IteratorProtocol) {
        self.action = action
        self.iterator = iterator
        
        let associated = action.associated
        
        let _ = NotificationCenter.default.publisher(for: Notification.Name(associated.label), object: nil)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
            },
            receiveValue: { [weak self] _ in
                let _ = self?.iterator.next()
                print("Receive notification")
            })
    }
    
    
    
    // https://www.hfoasi8fje3.work/entry/2021/07/14/%E3%80%90Combine%E3%80%91NotificationCenter%E3%81%A7%E3%81%AECombine%E3%81%AE%E5%88%A9%E7%94%A8
}
