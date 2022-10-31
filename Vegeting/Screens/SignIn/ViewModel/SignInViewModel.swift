//
//  SignInViewModel.swift
//  Vegeting
//
//  Created by yudonlee on 2022/10/25.
//

import Combine
import Foundation

import Firebase

final class SignInViewModel: ObservableObject {
    
    @Published var email: String?
    @Published var password: String?
    @Published var isRegistrationFormValid: Bool = false
    @Published var user: User?
    
    private var cancelBag: Set<AnyCancellable> = []
    
    func validateRegistrationForm() {
        guard let email = email, let password = password else {
            isRegistrationFormValid = false
            return
        }
        
        isRegistrationFormValid = email.count >= 4 && password.count >= 8
    }
    
    func createUser() {
        guard let email = email, let password = password else {
            return
        }
        
        FirebaseManager.shared.requestRegisterUser(email: email + "@MacVegeting.com", password: password)
            .sink { _ in
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &cancelBag)
    }
}
