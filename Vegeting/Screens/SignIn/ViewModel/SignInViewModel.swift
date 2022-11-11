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
        case appleSignInButtonTapped(tokenID: String)
        case kakaoSignInButtonTapped
    }
    
    enum Output {
        case isFirstSignIn
        case isAlreadySignIn
        case isSignInFailed(error: Error)
    }
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables =  Set<AnyCancellable>()
    
    private var tokenID: String?
    private var user: User?
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .appleSignInButtonTapped(let tokenID):
                self?.tokenID = tokenID
                self?.appleSignIn()
            case .kakaoSignInButtonTapped:
                print("kakaoButton")
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func appleSignIn() {
        guard let tokenID = tokenID else { return }
        
        let nonce = sha256(randomNonceString())
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenID, rawNonce: nonce)
        
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
    
    // Firebase에 애플 로그인을 위한 함수들(Firebase에서 유래)
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }

//    Firebase에 애플 로그인을 위한 함수들(Firebase에서 유래)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
}
