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
        case sendButtonTapped(text: String)
        case textChanged(height: CGFloat)
    }
    
    enum Output {
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
            case .textChanged(let height):
                self?.calculateTextViewHeight(height: height)
            case .sendButtonTapped(let text):
                self?.sendMessageFromLocal(text: text)
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
        
//        ?????? ?????? ????????? ????????????, ?????? ??????ID??? ?????? ????????? Sender ?????? ????????? ????????? ????????? ??? ??????.
        var previousSenderID = user.userID
        var messageDateLog: [String: Bool] = [:]
        
        return messages.flatMap { message -> [MessageBubble] in
//            ?????? ?????? ????????? ???????????? ???????????? ???????????? ??????
            var pairDateAndMessage = checkThisMessageNeedDate(messageDateLog: &messageDateLog, message: message)
            
//            ?????? ?????? ?????? ?????? ?????????, ?????? ?????? ?????????, ?????? ?????? ????????? + ?????????
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
            
//            [??????, ??? or?????? ?????? ?????????] or [??? or ?????? ?????? ?????????]??? ????????????.
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
        requestMessagesFromServer()
    }
}

