//
//  ChatRoomViewModel.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/13.
//

import Combine
import UIKit

struct TemporaryMessage {
    let status: MessageType
    let profileUserName: String
    let messageContent: String
}

struct MessageBubble {
    let message: Message
    let messageType: MessageType
}

final class ChatRoomViewModel: ViewModelType {
    
    enum Input {
        case viewWillAppear
        case sendButtonTapped(text: String)
        case textChanged(height: CGFloat)
    }
    
    enum Output {
        case participatedChatTitle(title: String)
        case localChatDataChanged(messageBubbles: [MessageBubble])
        case serverChatDataChanged(messageBubbles: [MessageBubble])
        case failToGetDataFromServer(error: Error)
        case textViewHeight(height: CGFloat)
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
                self?.setupNavigationTitle()
            case .textChanged(let height):
                self?.calculateTextViewHeight(height: height)
            case .sendButtonTapped(let text):
                self?.sendMessageFromLocal(text: text)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func setupNavigationTitle() {
        if let title = participatedChatRoom?.chatName {
            output.send(.participatedChatTitle(title: title))
        }
    }
    
    private func requestMessagesFromServer() {
        guard let participatedChatRoom = participatedChatRoom else { return }
        
        FirebaseManager.shared.requestChat(participatedChat: participatedChatRoom).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.output.send(.failToGetDataFromServer(error: error))
            }
        } receiveValue: { [weak self] chat in
            self?.chat = chat
            self?.updateLastReadIndex()
            let messageBubbles = self?.messagesToMessageBubbles(messages: chat.messages ?? []) ?? []
            self?.output.send(.serverChatDataChanged(messageBubbles: messageBubbles))
        }.store(in: &cancellables)
    }

    private func sendMessageFromLocal(text: String) {
        guard let user = self.user else { return }
        let message = Message(senderID: user.userID, senderName: user.userName, senderProfileImageURL: user.imageURL, contentType: "text", createdAt: Date(), content: text)
        if chat?.messages == nil {
            chat?.messages = []
        }
        chat?.messages?.append(message)
        guard let chat = chat, let messages = chat.messages else { return }
        let messageBubbles = messagesToMessageBubbles(messages: messages)
        output.send(.localChatDataChanged(messageBubbles: messageBubbles))
        Task {
            await FirebaseManager.shared.registerMessage(chat: chat, message: message)
        }
    }
    
    private func messagesToMessageBubbles(messages: [Message]) -> [MessageBubble] {
        guard let user = user else { return [] }
        
//        만약 이전 기록이 없더라도, 현재 유저ID로 하게 된다면 Sender 판단 로직에 오류가 발생할 수 없음.
        var previousSenderID = user.userID
        var messageDateLog: [String: Bool] = [:]
        
        return messages.flatMap { message -> [MessageBubble] in
//            해당 셀이 날짜가 필요한지 아닌지를 알려주는 로직
            var pairDateAndMessage = checkThisMessageNeedDate(messageDateLog: &messageDateLog, message: message)
            
//            해당 셀이 내가 보낸 메세지, 남이 보낸 메세지, 남이 보낸 메세지 + 프로필
            if message.senderID == user.userID {
                previousSenderID = message.senderID
                pairDateAndMessage.append(MessageBubble(message: message, messageType: .mine))
            } else if message.senderID == previousSenderID {
                previousSenderID = message.senderID
                pairDateAndMessage.append(MessageBubble(message: message, messageType: .other))
            } else {
                previousSenderID = message.senderID
                pairDateAndMessage.append(MessageBubble(message: message, messageType: .otherWithProfile))
            }
            
//            [날짜, 나 or남이 보낸 메세지] or [나 or 남이 보낸 메세지]가 리턴된다.
            return pairDateAndMessage
        }
    }
    
    private func checkThisMessageNeedDate(messageDateLog: inout [String: Bool], message: Message) -> [MessageBubble] {
        let date = message.createdAt.yearMonthDay()
        if messageDateLog[date] == nil {
            messageDateLog.updateValue(true, forKey: date)
            return [MessageBubble(message: message, messageType: .date)]
        } else {
            return []
        }
    }
    
    private func calculateTextViewHeight(height: CGFloat) {
        let lineCount = ((height - 45) / 21 + 1)
        let lineHeightMultiplier = min(lineCount - 1, 2)
        self.output.send(.textViewHeight(height: CGFloat(45 + lineHeightMultiplier * 21)))
    }
    
    func configure(participatedChatRoom: ParticipatedChatRoom, user: VFUser) {
        self.participatedChatRoom = participatedChatRoom
        self.user = user
        setupNavigationTitle()
        requestMessagesFromServer()
    }
    
    private func updateLastReadIndex() {
        Task { [weak self] in
            guard let participatedChatRoom = participatedChatRoom else { return }
            guard let messagesCount = self?.chat?.messages?.count else { return }
            guard let user = self?.user else { return }
            try await FirebaseManager.shared.updateLastReadIndex(user: user, participatedChatRoom: participatedChatRoom, index: messagesCount - 1)
        }
    }

}

