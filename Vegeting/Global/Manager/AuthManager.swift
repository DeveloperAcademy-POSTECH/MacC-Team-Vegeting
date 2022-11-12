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
    static let auth = Auth.auth()

    private init() { }
    
    func signInUser(email: String, password: String) -> AnyPublisher<User, Error> {
        return AuthManager.auth.signIn(withEmail: email, password: password)
            .catch { error in
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }.map(\.user)
            .eraseToAnyPublisher()
    }
    
    func signInUser(with credential: OAuthCredential) -> AnyPublisher<User, Error> {
        
        return AuthManager.auth.signIn(with: credential)
            .catch { error in
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }.map(\.user)
            .eraseToAnyPublisher()

    }
    
}
