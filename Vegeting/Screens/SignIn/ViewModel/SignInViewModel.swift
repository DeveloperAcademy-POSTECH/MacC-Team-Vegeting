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
import KakaoSDKAuth
import KakaoSDKUser

final class SignInViewModel {
    typealias FirebaseUser = FirebaseAuth.User
    typealias KakaoUser = KakaoSDKUser.User
    
    enum Input {
        case appleSignInEventOccurred(tokenID: String)
        case kakaoSignInButtonTapped
    }
    
    enum Output {
        case didFirstSignInWithApple
        case didAlreadySignInWithApple
        case didFailToSignInWithApple(error: Error)
        
        case didFirstSignInWithKakao
        case didAlreadySignInWithKakao
        case didFailToSignInWithKakao(error: Error)
    }
    
    enum SignInType {
        case kakao
        case apple
    }
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables =  Set<AnyCancellable>()
    
    private var tokenID: String?
    private var user: FirebaseUser?
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .appleSignInEventOccurred(let tokenID):
                self?.tokenID = tokenID
                self?.appleSignIn()
            case .kakaoSignInButtonTapped:
                self?.kakaoSignIn()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    /// 카카오 로그인 이벤트 시작(웹과 앱 로그인으로 구분)
    private func kakaoSignIn() {
        if UserApi.isKakaoTalkLoginAvailable() {
            signInWithKakaoTalkApp()
        } else {
            signInWithKakaoWeb()
        }
    }
    
    /// 카카오 앱을 통한 로그인
    private func signInWithKakaoTalkApp() {
        UserApi.shared.loginWithKakaoTalk { [weak self] _, error in
            if let error = error {
                self?.output.send(.didFailToSignInWithKakao(error: error))
            }
            self?.validateKakaoUserData()
        }
    }
    
    /// 카카오 웹을 통한 로그인
    private func signInWithKakaoWeb() {
        UserApi.shared.loginWithKakaoAccount { [weak self] _, error in
            if let error = error {
                self?.output.send(.didFailToSignInWithKakao(error: error))
            }
            self?.validateKakaoUserData()
        }
    }
    
    /// 카카오 로그인 데이터 정보를 받고, 해당 정보가 유효하면 FirebaseAuth에 로그인을 시도합니다.
    private func validateKakaoUserData() {
        UserApi.shared.me { [weak self] kakaoUser, error in
            if let error = error {
                self?.output.send(.didFailToSignInWithKakao(error: error))
            } else {
                self?.registerKakaoUserToAuth(user: kakaoUser)
            }
                
        }
    }
    
    /// 카카오 로그인이 성공할 때, 해당 유저가 Firebase Auth에 등록 or 등록된지 별도 확인
    private func registerKakaoUserToAuth(user kakaoUser: KakaoUser?) {
        guard let email = kakaoUser?.kakaoAccount?.email, let password = kakaoUser?.id else { return }
        AuthManager.shared.registerUser(email: email, password: String(password)).sink { [weak self] completion in
            if case .failure(let error) = completion {
                if AuthErrorCode.emailAlreadyInUse.rawValue == (error as NSError).code {
                    self?.validateKakaoUserInAuth(user: kakaoUser)
                }
                self?.output.send(.didFailToSignInWithKakao(error: error))
            }
        } receiveValue: { [weak self] user in
            self?.validateKakaoUserInAuth(user: kakaoUser)
        }.store(in: &cancellables)

    }
    
    /// 카카오 Auth에 로그인(카카오 유저가 정상적으로 Auth에 로그인 가능한 상태인지 확인)
    private func validateKakaoUserInAuth(user: KakaoUser?) {
        
        guard let email = user?.kakaoAccount?.email, let password = (user?.id) else { return }
        AuthManager.shared.signInUser(email: email, password: String(password)).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.output.send(.didFailToSignInWithKakao(error: error))
            }
        } receiveValue: { [weak self] user in
            self?.user = user
            self?.didUserAlreadyRegisterInFirestore(type: .kakao)
        }.store(in: &cancellables)
    }
    
    /// 애플 로그인을 통해 들어온 정보를 가지고 Firebase에 로그인
    private func appleSignIn() {
        guard let tokenID = tokenID else { return }
        
        let nonce = sha256(randomNonceString())
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenID, rawNonce: nonce)
        
        AuthManager.shared.signInUser(with: credential)
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.output.send(.didFailToSignInWithApple(error: error))
                }
            } receiveValue: { [weak self] user in
                self?.user = user
                self?.didUserAlreadyRegisterInFirestore(type: .apple)
            }.store(in: &self.cancellables)
        
    }
    
    
    /// Firebase Auth에 로그인 했다면, 해당 유저가 Firestore에 등록된지 확인(첫 로그인인지 아닌지 판단)
    private func didUserAlreadyRegisterInFirestore(type: SignInType) {
        guard let user = user else { return }
        
        FirebaseManager.shared.isUserAlreadyExisted(user: user)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.output.send(type == .apple ?
                        .didFailToSignInWithApple(error: error) : .didFailToSignInWithKakao(error: error))
                }
            } receiveValue: { [weak self] status in
                switch type {
                case .apple:
                    self?.output.send(status ? .didAlreadySignInWithApple : .didFirstSignInWithApple)
                case .kakao:
                    self?.output.send(status ? .didAlreadySignInWithKakao : .didFirstSignInWithKakao)
                }
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
