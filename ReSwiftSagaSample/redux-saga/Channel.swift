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
    
    public var dispatch: DispatchFunction? = nil
    public var getState: (() -> Any?)? = nil
    
    /**
     action を発行する
     */
    func put(_ action: SagaAction){
        subject.send(action)
    }
    
    /**
     特定の action を監視する
     */
    func take(_ actionType: SagaAction.Type, receive: @escaping (_ action: SagaAction) -> Void ){
        // 監視は一度限りで行い、検出後は破棄する
        // 破棄しないと、検出した action を対応にした場合、withCheckedContinuation で二重呼び出しにカウントされクラッシュする
        var cancellable: AnyCancellable? = nil
        cancellable = subject.filter {
            type(of: $0) == actionType
        }.sink { [weak self] in
            self?.complete($0)
            cancellable?.cancel()
        } receiveValue: {
            receive($0)
            cancellable?.cancel()
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
}
