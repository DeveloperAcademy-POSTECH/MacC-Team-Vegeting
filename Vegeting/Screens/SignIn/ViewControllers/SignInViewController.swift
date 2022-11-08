//
//  SignInViewController.swift
//  Vegeting
//
//  Created by yudonlee on 2022/10/25.
//

import AuthenticationServices
import UIKit

class SignInViewController: UIViewController {

    private let brandingImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        return button
    }()
    
    private lazy var kakaoSignInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakao_login_large_wide"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        configureUI()
    }
    
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
