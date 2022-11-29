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

struct MessageBubble {
    let message: Message
    let senderType: SenderType
}

final class ChatRoomViewModel: ViewModelType {
    
    enum Input {
        case viewWillAppear
        case sendButtonTapped(text: String)
    }
    
    enum Output {
        case localChatDataChanged(messageBubbles: [MessageBubble])
        case serverChatDataChanged(messageBubbles: [MessageBubble])
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
            case .sendButtonTapped(let text):
                self?.sendMessageFromLocal(text: text)
                break
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func requestMessagesFromServer() {
        guard let participatedChatRoom = participatedChatRoom else { return }
        
        FirebaseManager.shared.requestChat(participatedChat: participatedChatRoom).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.output.send(.failToGetDataFromServer(error: error))
            }
        } receiveValue: { [weak self] chat in
            self?.chat = chat
            let messageBubbles = self?.messagesToMessageBubbles(messages: chat.messages ?? []) ?? []
            self?.output.send(.serverChatDataChanged(messageBubbles: messageBubbles))
        }.store(in: &cancellables)
    }

    private func sendMessageFromLocal(text: String) {
        guard let user = self.user else { return }
        let message = Message(senderID: user.userID, senderName: user.userName, senderProfileImageURL: user.imageURL, contentType: "text", createdAt: Date(), imageURL: nil, content: text)
        if chat?.messages == nil {
            chat?.messages = []
        }
        chat?.messages?.append(message)
        guard let chat = chat, let messages = chat.messages else { return }
        let messageBubbles = messagesToMessageBubbles(messages: messages)
        output.send(.localChatDataChanged(messageBubbles: messageBubbles))
        Task {
            await FirebaseManager.shared.sendMessage(chat: chat, message: message)
        }
    }
    
    private func messagesToMessageBubbles(messages: [Message]) -> [MessageBubble] {
        guard let user = user else { return [] }
        
//        만약 이전 기록이 없더라도, 현재 유저ID로 하게 된다면 Sender 판단 로직에 오류가 발생할 수 없음.
        var previousSenderID = user.userID
        
        return messages.map { message in
            if message.senderID == user.userID {
                previousSenderID = message.senderID
                return MessageBubble(message: message, senderType: .mine)
            } else if message.senderID == previousSenderID {
                previousSenderID = message.senderID
                return MessageBubble(message: message, senderType: .other)
            } else {
                previousSenderID = message.senderID
                return MessageBubble(message: message, senderType: .otherWithProfile)
            }
        }
    }
    
    func configure(participatedChatRoom: ParticipatedChatRoom, user: VFUser) {
        self.participatedChatRoom = participatedChatRoom
        self.user = user
        requestMessagesFromServer()
    }
    
}

