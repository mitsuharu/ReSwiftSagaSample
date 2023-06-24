//
//  Channel.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/16.
//

import Foundation
import Combine
import ReSwift

/**
 Channel
 - Saga に Action を通知する
 - 特定の Action の監視する
 */
final class Channel {
    
    public static let shared = Channel()
    private let subject = PassthroughSubject<SagaAction, Error>()
    private var subscriptions = [AnyCancellable]()
    
    public var dispatch: DispatchFunction? = nil
    public var getState: (() -> Any?)? = nil
    
    deinit{
        cancel()
    }
    
    /**
     action を発行する
     */
    func put(_ action: SagaAction){
        subject.send(action)
    }
      
    /**
     特定の action が発行されるまで監視する
     */
    func take(_ actionType: SagaAction.Type ) -> Future <SagaAction, Never> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            self.subject.filter {
                type(of: $0) == actionType
            }.sink { [weak self] in
                self?.complete($0)
            } receiveValue: {
                promise(.success($0))
            }.store(in: &self.subscriptions)
        }
    }
    
    /**
     エラー時の処理
     @TODO: エラーを投げるかは検討
     */
    private func complete(_ completion: Subscribers.Completion<Error>){
        switch completion {
        case .finished:
            print("Channel#finished")
        case .failure(let error):
            assertionFailure("Channel#failure \(error)")
        }
    }
    
    private func cancel(){
        subscriptions.forEach { $0.cancel() }
    }
}
