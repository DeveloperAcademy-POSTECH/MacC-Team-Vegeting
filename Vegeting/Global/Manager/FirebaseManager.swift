//
//  FirebaseManager.swift
//  Vegeting
//
//  Created by yudonlee on 2022/10/25.
//

import Combine
import Foundation

import Firebase
import FirebaseAuthCombineSwift

final class FirebaseManager {
    static let shared = FirebaseManager()
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    
    private enum Path: String {
        case user = "Users"
        case club = "Clubs"
        case chat = "Chats"
    }
    
    
    //    TODO: 추후 회원가입을 위한 Model 따로 만들기
    /// 파이어베이스 스토어에 User정보 등록하는 함수
    /// - Parameter vfUser: vfUser로 넘어옴
    func registerUser(with vfUser: VFUser) {
        
        do {
            let user = VFUser(userID: vfUser.userID,
                              userName: vfUser.userName,
                              imageURL: vfUser.imageURL,
                              participatedChats: vfUser.participatedChats,
                              participatedClubs: vfUser.participatedClubs)
            try db.collection(Path.user.rawValue).document(user.userID).setData(from: user)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// 클럽 정보 받아오기
    /// - Returns: 모든 클럽 정보가 나타난다.
    func requestClubInformation() async -> [Club]? {
        
        do {
            let documents = try await db.collection(Path.club.rawValue).getDocuments()
            let data = documents.documents.compactMap { snapshot in
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
            
            let participant = Participant(userID: user.userID,
                                          name: user.userName,
                                          imageURL: user.imageURL)
            let addedClub = Club(clubID: docClub.documentID,
                                 chatID: docChat.documentID,
                                 clubTitle: club.clubTitle,
                                 clubCategory: club.clubCategory,
                                 hostID: user.userID,
                                 participants: [participant],
                                 createdAt: club.createdAt,
                                 maxNumberOfPeople: club.maxNumberOfPeople)
            
            let addedChat = Chat(chatRoomID: docChat.documentID,
                                 clubID: docClub.documentID,
                                 chatRoomName: chat.chatRoomName,
                                 participants: [participant],
                                 messages: nil,
                                 coverImageURL: chat.coverImageURL)
            
            try docClub.setData(from: addedClub)
            try docChat.setData(from: addedChat)
            
            return (docClub.documentID, docChat.documentID)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    /// 모임 ID와 채팅 ID 서로 가지기
    private func requestUpdateUser(user: VFUser, participatedChatRoom: ParticipatedChatRoom, participatedClub: ParticipatedClub) {
        
        do {
            let doc = db.collection(Path.user.rawValue).document(user.userID)
            let encodedParticipatedClub = try Firestore.Encoder().encode(participatedClub)
            let encodedParticipatedChat = try Firestore.Encoder().encode(participatedChatRoom)
            doc.updateData(["participatedClub": FieldValue.arrayUnion([encodedParticipatedClub]), "participatedChat": FieldValue.arrayUnion([encodedParticipatedChat])])
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    /// 첫 Club 모임 생성
    func requestPost(user: VFUser, club: Club, chat: Chat) {
        let result = registerChatAndPost(user: user, club: club, chat: chat)
        
        guard let result = result else { return }
        
        let participatedClub = ParticipatedClub(clubID: result.clubID, clubName: club.clubTitle, profileImageURL: club.coverImageURL)
        let participatedChatRoom = ParticipatedChatRoom(chatID: result.chatID, chatName: chat.chatRoomName, imageURL: chat.coverImageURL)
        
        requestUpdateUser(user: user, participatedChatRoom: participatedChatRoom, participatedClub: participatedClub)
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
}
