//
//  AuthManager.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/03.
//

import Combine
import Foundation

import FirebaseAuth
import FirebaseAuthCombineSwift

final class AuthManager {
    
    static let shared = AuthManager()
    private let auth = Auth.auth()
    private var user: VFUser?
    
    private init() {
        FirebaseManager.shared.requestUser { result in
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func currentUser() -> VFUser? {
        return self.user
    }

    /// 로그인이 Valid한지 판단하는 함수
    func isSignInValid() -> Bool {
        return (auth.currentUser != nil) ? true : false
    }
    
    /// 유저의 로그인 및 프로필 등록상태에 따른 RootViewController 케이스 리턴
    func rootNavigationBySignInStatus() async -> RootNavigation {
        if let user = auth.currentUser {
            do {
                let isUserProfileAlreadyStored = try await FirebaseManager.shared.isUserAlreadyExisted(user: user)
                return isUserProfileAlreadyStored ? RootNavigation.mainTabbarController : RootNavigation.userProfileViewController
            } catch {
                print(error.localizedDescription)
            }
        }
        return RootNavigation.signInViewController
    }
}

// MARK: FirebaseAuth에 로그인 및 로그아웃 함수들
extension AuthManager {
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
    
    func signInUser(email: String, password: String) -> AnyPublisher<User, Error> {
        return auth.signIn(withEmail: email, password: password)
            .catch { error in
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }.map(\.user)
            .eraseToAnyPublisher()
    }
    
    func signInUser(with credential: OAuthCredential) -> AnyPublisher<User, Error> {
        return auth.signIn(with: credential)
            .catch { error in
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }.map(\.user)
            .eraseToAnyPublisher()
    }
    
    func requestSignOut() {
        do {
            try auth.signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: FirebaseManager에 회원가입 및 회원탈퇴 함수들
extension AuthManager {
    /// Firebase Authentification에 등록하는 함수
    /// - Returns: Firebase User 객체
    func registerUser(email: String, password: String) -> AnyPublisher<User, Error> {
        return auth.createUser(withEmail: email, password: password)
            .catch { error in
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }.map(\.user)
            .eraseToAnyPublisher()
    }
}
