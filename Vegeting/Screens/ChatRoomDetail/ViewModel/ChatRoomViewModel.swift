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
            self?.output.send(.serverChatDataChanged(messages: self?.chat?.messages ?? []))
        }.store(in: &cancellables)
    }

    private func sendMessageFromLocal(text: String) {
        guard let user = self.user else { return }
        let message = Message(senderID: user.userID, senderName: user.userName, senderProfileImageURL: user.imageURL, contentType: "text", createdAt: Date(), imageURL: nil, content: text)
        chat?.messages?.append(message)
        
        guard let chat = chat, let messages = chat.messages else { return }
        output.send(.localChatDataChanged(messages: messages))
        
        Task {
            await FirebaseManager.shared.registerMessage(chat: chat, message: message)
        }
    }
    
    func configure(participatedChatRoom: ParticipatedChatRoom, user: VFUser) {
        self.participatedChatRoom = participatedChatRoom
        self.user = user
        requestMessagesFromServer()
    }
}

