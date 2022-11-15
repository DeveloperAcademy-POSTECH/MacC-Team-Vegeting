//
//  SignInViewController.swift
//  Vegeting
//
//  Created by yudonlee on 2022/10/25.
//

import AuthenticationServices
import Combine
import CryptoKit
import UIKit

class SignInViewController: UIViewController {
    
    private let brandingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.addTarget(self, action: #selector(appleSignInButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var kakaoSignInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakao_login_large_wide"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(kakaoSignInButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private var viewModel = SignInViewModel()
    private let input: PassthroughSubject<SignInViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        Layout 설정 및 UI 컴포넌트 구성
        configureUI()
        setupLayout()
        
        bind()
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.sink { [weak self] event in
            switch event {
            case .didFirstSignInWithApple, .didFirstSignInWithKakao:
//                TODO: Profile 생성 ViewController로 이동하도록 구현
                self?.navigationController?.pushViewController(UserProfileViewController(), animated: true)
                break
            case .didFailToSignInWithApple(let error), .didFailToSignInWithKakao(let error):
                print(error.localizedDescription)
            case .didAlreadySignInWithApple, .didAlreadySignInWithKakao:
                self?.navigationController?.dismiss(animated: true)
            }
        }.store(in: &cancellables)
    }
    
}

// MARK: 로그인 버튼 관련 함수
extension SignInViewController {
    
    @objc private func appleSignInButtonTapped(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authrizationController = ASAuthorizationController(authorizationRequests: [request])
        authrizationController.delegate = self
        authrizationController.presentationContextProvider = self
        authrizationController.performRequests()
    }
    
    @objc private func kakaoSignInButtonTapped(_ sender: Any) {
        input.send(.kakaoSignInButtonTapped)
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if case let appleIDCredential as ASAuthorizationAppleIDCredential = authorization.credential {
            guard let appleIDToken = appleIDCredential.identityToken else { return }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return }
            
            input.send(.appleSignInEventOccurred(tokenID: idTokenString))
        }
    }
    
}


// MARK: Layout 및 UI설정 함수
extension SignInViewController {
    
    private func setupLayout() {
        let brandingImageViewConstraints = [
            brandingImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            brandingImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            brandingImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            brandingImageView.heightAnchor.constraint(equalToConstant: 270)
        ]
        let kakaoSignInButtonConstriants = [
            kakaoSignInButton.bottomAnchor.constraint(equalTo: appleSignInButton.topAnchor, constant: -20),
            kakaoSignInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            kakaoSignInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ]
        
        let appleSignInButtonConstraints =  [
            appleSignInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            appleSignInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            appleSignInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            appleSignInButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        constraintsActivate(kakaoSignInButtonConstriants, appleSignInButtonConstraints,brandingImageViewConstraints)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubviews(appleSignInButton, kakaoSignInButton, brandingImageView)
    }
    
}
