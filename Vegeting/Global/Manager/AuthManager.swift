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
    private var currentUser: VFUser?
    
    private init() {
        FirebaseManager.shared.requestUser { result in
            switch result {
            case .success(let user):
                self.currentUser = user
            case .failure(let error):
                print(error.localizedDescription)
            }
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

    func registerUser(email: String, password: String) -> AnyPublisher<User, Error> {
        return auth.createUser(withEmail: email, password: password)
            .catch { error in
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }.map(\.user)
            .eraseToAnyPublisher()
    }
    
    func fetchCurrentUser() -> VFUser? {
        return self.currentUser
    }
    
}
