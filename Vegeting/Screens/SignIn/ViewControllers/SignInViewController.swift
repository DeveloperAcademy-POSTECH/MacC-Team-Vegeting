//
//  SignInViewController.swift
//  Vegeting
//
//  Created by yudonlee on 2022/10/25.
//

import Combine
import UIKit

class SignInViewController: UIViewController {
    
//    MARK: viewModel등 Combine 관련 요소
    private var viewModel = SignInViewModel()
    private var cancelBag: Set<AnyCancellable> = []
    
//    MARK: UI Component 영역
    private let registerTitleLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "아이디를 로그인하세요!(없으면 자동생성됨)"
        label.font = .systemFont(ofSize: 20 , weight: .bold)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Email(4자이상)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.layer.borderColor = UIColor.blue.cgColor
        
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Password(8자이상)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        textField.layer.borderColor = UIColor.blue.cgColor
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    private let registerButton: UIButton = {

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        configureConstraints()
        hideKeyboardWhenTappedAround()
        bindViews()
    }
    
    /// view를 바인딩 할 때 사용합니다.
    private func bindViews() {
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(didChangeEmailTextField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePasswordTextField), for: .editingChanged)
        
        viewModel.$isRegistrationFormValid.sink { [weak self] validationState in
            self?.registerButton.isEnabled = validationState
        }
        .store(in: &cancelBag)
        
        viewModel.$user.sink { [weak self] user in
            guard user != nil else { return }
            self?.navigationController?.dismiss(animated: true)
        }
        .store(in: &cancelBag)
    }
    
    
    
    
}

// MARK: Constraint 및 UI 관련 함수
extension SignInViewController {
    
    private func setupLayout() {
        view.addSubviews(emailTextField, passwordTextField, registerTitleLabel, registerButton)
        view.backgroundColor = .systemBackground
        view.backgroundColor = .white
    }
    
    private func configureConstraints() {
        let registerTitleLabelConstraints = [
            registerTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ]
        
        let emailTextFieldConstraints = [
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.topAnchor.constraint(equalTo: registerTitleLabel.bottomAnchor, constant: 16),
            emailTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let passwordTextFieldConstraints = [
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let registerButtonConstraints = [
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            registerButton.widthAnchor.constraint(equalToConstant: 100),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        constraintsActivate(registerTitleLabelConstraints,emailTextFieldConstraints, passwordTextFieldConstraints, registerButtonConstraints)
    }
    
}

// MARK: UI component Delegate 지정
extension SignInViewController {
    
    @objc private func didChangeEmailTextField() {
        viewModel.email = emailTextField.text
        viewModel.validateRegistrationForm()
    }
    
    @objc private func didChangePasswordTextField() {
        viewModel.password = passwordTextField.text
        viewModel.validateRegistrationForm()
    }
    
    @objc private func didTapRegisterButton() {
        viewModel.createUser()
    }
    
    
}
