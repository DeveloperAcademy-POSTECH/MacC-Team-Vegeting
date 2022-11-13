//
//  ChatRoomViewModel.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/13.
//

import Combine
import Foundation

struct TemporaryMessage {
    let status: SenderType
    let profileUserName: String
    let messageContent: String
}

final class ChatRoomViewModel: ViewModelType {
    
    enum Input {
        case viewWillAppear
        case sendButtonTapped(text: String)
    }
    
    enum Output {
        case localChatDataChanged(messages: [Message])
        case serverChatDataChanged(messages: [Message])
        case failToGetDataFromServer(error: Error)
    }
    
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private var participatedChatRoom: ParticipatedChatRoom?
    private var chat: Chat?
    private var user: VFUser?
    
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewWillAppear:
                break
//                self?.messagesFromServer()
            case .sendButtonTapped(let text):
//                self?.sendMessageFromLocal(text: text)
                break
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
}

