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

    private init() { }
    
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

    func registerUser(email: String, password: String) -> AnyPublisher<User, Error> {
        return auth.createUser(withEmail: email, password: password)
            .catch { error in
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }.map(\.user)
            .eraseToAnyPublisher()
    }
    
    func isSignInValid() -> Bool {
        return (auth.currentUser != nil) ? true : false
    }
    
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
