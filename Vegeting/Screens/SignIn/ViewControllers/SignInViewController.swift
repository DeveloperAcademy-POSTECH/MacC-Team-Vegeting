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
            case .isFirstSignIn:
                let navigationController = UINavigationController(rootViewController: FirstCreateGroupViewController())
                self?.navigationController?.pushViewController(navigationController, animated: true)
            case .isSignInFailed(let error):
                print(error.localizedDescription)
            case .isAlreadySignIn:
                self?.navigationController?.dismiss(animated: true)
            }
        }.store(in: &cancellables)
    }
    
}

// MARK: apple로 로그인하기 관련 함수
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
    
}

extension SignInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if case let appleIDCredential as ASAuthorizationAppleIDCredential = authorization.credential {
            guard let appleIDToken = appleIDCredential.identityToken else { return }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return }
            
            input.send(.appleSignInButtonTapped(tokenID: idTokenString))
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
