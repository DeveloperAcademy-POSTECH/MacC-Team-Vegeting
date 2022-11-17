//
//  FirebaseManager.swift
//  Vegeting
//
//  Created by yudonlee on 2022/10/25.
//

import Combine
import Foundation

import Firebase
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import FirebaseAuthCombineSwift

final class FirebaseManager {
    static let shared = FirebaseManager()
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    
    private enum Path: String {
        case user = "Users"
        case club = "Clubs"
        case chat = "Chats"
        case recentChat = "RecentChats"
    }
    
    //    TODO: 추후 회원가입을 위한 Model 따로 만들기
    /// 파이어베이스 스토어에 User정보 등록하는 함수
    /// - Parameter vfUser: vfUser로 넘어옴
    func requestUserInformation(with user: VFUser) {
        do {
            try db.collection(Path.user.rawValue).document(user.userID).setData(from: user)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// 클럽 정보 받아오기
    /// - Returns: 모든 클럽 정보가 나타난다.
    func requestClubInformation() async -> [Club]? {
        do {
            let querySnapshot = try await db.collection(Path.club.rawValue).getDocuments()
            let data = querySnapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: Club.self)
            }
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}

// MARK: Firebase 첫 모임생성
extension FirebaseManager {
    
    func registerChatAndPost(user: VFUser, club: Club, chat: Chat) -> (clubID: String, chatID: String)? {
        do {
            let docChat = db.collection(Path.chat.rawValue).document()
            let docClub = db.collection(Path.club.rawValue).document()
            let docRecentChat = db.collection(Path.recentChat.rawValue).document(docChat.documentID)
            
            let participant = Participant(userID: user.userID, name: user.userName, profileImageURL: user.imageURL)
            let addedClub = Club(clubID: docClub.documentID, chatID: docChat.documentID,
                                 clubTitle: club.clubTitle, clubCategory: club.clubCategory,
                                 clubContent: club.clubContent, hostID: user.userID,
                                 participants: [participant], dateToMeet: club.dateToMeet,
                                 createdAt: club.createdAt, placeToMeet: club.placeToMeet,
                                 maxNumberOfPeople: club.maxNumberOfPeople, coverImageURL: club.coverImageURL)
            
            let addedChat = Chat(chatRoomID: docChat.documentID, clubID: docClub.documentID,
                                 chatRoomName: chat.chatRoomName, participants: [participant],
                                 messages: nil, coverImageURL: chat.coverImageURL)
            
            let recentChat = RecentChat(chatRoomID: docChat.documentID, chatRoomName: chat.chatRoomName
                                        ,lastSentMessage: nil, lastSentTime: Date(), coverImageURL: chat.coverImageURL)
            
            try docClub.setData(from: addedClub)
            try docChat.setData(from: addedChat)
            try docRecentChat.setData(from: recentChat)
            return (docClub.documentID, docChat.documentID)
            
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    /// 모임 ID와 채팅 ID 서로 가지기
    private func requestUpdateUser(user: VFUser, participatedChatRoom: ParticipatedChatRoom, participatedClub: ParticipatedClub) {
        
        do {
            let document = db.collection(Path.user.rawValue).document(user.userID)
            let encodedParticipatedClub = try Firestore.Encoder().encode(participatedClub)
            let encodedParticipatedChat = try Firestore.Encoder().encode(participatedChatRoom)
            document.updateData(["participatedClubs": FieldValue.arrayUnion([encodedParticipatedClub]), "participatedChats": FieldValue.arrayUnion([encodedParticipatedChat])])
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    /// 첫 Club 모임 생성
    func requestPost(user: VFUser, club: Club, chat: Chat) {
        let result = registerChatAndPost(user: user, club: club, chat: chat)
        
        guard let result = result else { return }
        
        let participatedClub = ParticipatedClub(clubID: result.clubID, clubName: club.clubTitle ?? "", profileImageURL: club.coverImageURL)
        let participatedChatRoom = ParticipatedChatRoom(chatID: result.chatID, chatName: chat.chatRoomName, imageURL: chat.coverImageURL)
        
        requestUpdateUser(user: user, participatedChatRoom: participatedChatRoom, participatedClub: participatedClub)
    }
    
}

// MARK: Firebase 채팅
extension FirebaseManager {
    //  채팅창 정보 불러오기(한 채팅방 아이디로)
    func requestChat(participatedChat: ParticipatedChatRoom) async -> Chat? {
        guard let chatID = participatedChat.chatID else { return nil }
        do {
            let data = try await db.collection(Path.chat.rawValue).document(chatID).getDocument().data(as: Chat.self)
            return data
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    //   채팅창 정보 불러오기(유저가 갖고 있는 chatting방 전체)
    func requestAllChats(user: VFUser) async -> [Chat]? {
        guard let participatedChats = user.participatedChats else { return nil }
        let chatList = participatedChats.map { $0.chatID }
        
        do {
            let result = try await db.collection("Chats").whereField(FieldPath.documentID(), in: chatList as [Any]).getDocuments().documents.compactMap { querySnapShot in
                try querySnapShot.data(as: Chat.self)
            }
            
            return result
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    /// 채팅 보내기
    func registerMessage(chat: Chat, message: Message) async {
        await sendMessage(chat: chat, message: message)
        registerRecentMessageOnChat(chat: chat, message: message)
    }
    
    func sendMessage(chat: Chat, message: Message) async {
        guard let chatID = chat.chatRoomID else { return }
        do {
            let message = try Firestore.Encoder().encode(message)
            try await db.collection(Path.chat.rawValue).document(chatID).updateData(["messages": FieldValue.arrayUnion([message])])
        } catch {
            print(error.localizedDescription)
        }
    }

    func requestChat(participatedChat: ParticipatedChatRoom) -> AnyPublisher<Chat, Error> {
        guard let chatID = participatedChat.chatID else { return Fail(error: ErrorLiteral.emptyChatID).eraseToAnyPublisher() }
        return db.collection(Path.chat.rawValue).document(chatID).snapshotPublisher(includeMetadataChanges: true)
            .catch { error in
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }
            .tryMap { try $0.data(as: Chat.self) }
            .eraseToAnyPublisher()
    }
    
    func registerRecentMessageOnChat(chat: Chat, message: Message) {
        guard let chatID = chat.chatRoomID else { return }
        do {
            let recentChat = RecentChat(chatRoomID: chatID, chatRoomName: chat.chatRoomName, lastSentMessage: message.content, lastSentTime: message.createdAt, coverImageURL: chat.coverImageURL)
            try db.collection(Path.recentChat.rawValue).document(chatID).setData(from: recentChat)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func requestRecentChat(user: VFUser) -> AnyPublisher<[RecentChat], Error> {
        guard let participatedChatRoomIDs =  user.participatedChats?.compactMap(\.chatID) else {
            return Fail(error: FBError.didFailToLoadChat)
                .eraseToAnyPublisher()
        }
        
        return db.collection(Path.recentChat.rawValue).whereField(FieldPath.documentID(), in: participatedChatRoomIDs).snapshotPublisher()
            .tryMap { try $0.documents.compactMap { try $0.data(as: RecentChat.self) } }
            .eraseToAnyPublisher()
    }
    
    func requestRecentChat(user: VFUser, completion: @escaping (Result<[RecentChat], Error>) -> Void) {
        guard let participatedChatRoomIDs =  user.participatedChats?.compactMap(\.chatID) else { return }
        
        db.collection(Path.recentChat.rawValue).whereField(FieldPath.documentID(), in: participatedChatRoomIDs).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(error))
            } else {
                let datas = querySnapshot!.documents.map { try? $0.data(as: RecentChat.self) }
                let recentChats = datas.compactMap({ $0 })
                completion(.success(recentChats))
            }
        }
    }
}

// MARK: Firebase Authentifcation 전용(유저 회원가입 및 로그인 담당)
extension FirebaseManager {
    //  MARK: 유저 회원가입
    /// Firebase Authentification에 등록하는 함수
    /// - Returns: Firebase User 객체
    func requestRegisterUser(email: String, password: String) -> AnyPublisher<User, Error> {
        return Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
    
    /// Firebase Authentification에 로그인 하는 함수
    /// - Returns: Firebase 유저정보
    func requestSignIn(email: String, password: String) async -> User? {
        do {
            let data = try await auth.signIn(withEmail: email, password: password)
            return data.user
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func requestSignOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func requestUser() async -> VFUser? {
        guard let uid = auth.currentUser?.uid else { return nil}
        do {
            let user = try await db.collection(Path.user.rawValue).document(uid).getDocument().data(as: VFUser.self)
            return user
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func isUserAlreadyExisted(user: User) -> AnyPublisher<Bool, Error> {
        return db.collection(Path.user.rawValue).document(user.uid).getDocument()
            .catch { error in
                return Fail(error: error)
                    .eraseToAnyPublisher()
            } .map(\.exists)
            .eraseToAnyPublisher()
        
    }
}
