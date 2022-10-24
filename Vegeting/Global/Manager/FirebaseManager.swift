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
    
    func requestRegisterUser(email: String, password: String) -> AnyPublisher<User, Error> {
        return Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
}
