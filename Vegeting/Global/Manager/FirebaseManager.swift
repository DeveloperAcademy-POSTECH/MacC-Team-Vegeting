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
    func requestUserInformation(with vfUser: VFUser) {
        guard let uid = auth.currentUser?.uid else { return }
        do {
            let user = VFUser(userID: uid, userName: vfUser.userName, imageURL: vfUser.imageURL, participatedChats: vfUser.participatedChats, participatedClubs: vfUser.participatedClubs)
            try db.collection(Path.user.rawValue).document(uid).setData(from: user)

        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    /// 유저가 모임을 모집하는 글을  작성하는 함수
    func requestPost(with club: Club) {
        guard let uid = auth.currentUser?.uid else { return }
        do {
            let doc = db.collection(Path.club.rawValue).document()
            let club = Club(clubID: doc.documentID, clubTitle: club.clubTitle, clubCategory: club.clubCategory, hostID: club.hostID, participants: club.participants, createdAt: Date(), maxNumberOfPeople: club.maxNumberOfPeople)
            try doc.setData(from: club)
            
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
}
