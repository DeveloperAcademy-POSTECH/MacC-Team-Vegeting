//
//  SignInViewModel.swift
//  Vegeting
//
//  Created by yudonlee on 2022/10/25.
//

import Combine
import CryptoKit
import Foundation

import Firebase

final class SignInViewModel {
    
    enum Input {
        case appleSignInButtonTapped(credential: OAuthCredential)
        case kakaoSignInButtonTapped
    }
    
    enum Output {
        case isFirstSignIn
        case isAlreadySignIn
        case isSignInFailed(error: Error)
    }
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables =  Set<AnyCancellable>()
    
    private var credential: OAuthCredential?
    private var user: User?
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .appleSignInButtonTapped(let credential):
                self?.credential = credential
                self?.appleSignIn()
            case .kakaoSignInButtonTapped:
                print("kakaoButton")
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func appleSignIn() {
        guard let credential = credential else { return }

        AuthManager.shared.signInUser(with: credential)
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.output.send(.isSignInFailed(error: error))
                }
            } receiveValue: { [weak self] user in
                self?.user = user
                self?.isAccountAlreadyRegistered()
            }.store(in: &self.cancellables)
        
    }
    
    func isAccountAlreadyRegistered() {
        guard let user = user else { return }
        FirebaseManager.shared.isUserAlreadyExisted(user: user)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.output.send(.isSignInFailed(error: error))
                }
            } receiveValue: { [weak self] status in
                self?.output.send(status ? .isAlreadySignIn : .isFirstSignIn)
            }.store(in: &cancellables)
    }
    
}
