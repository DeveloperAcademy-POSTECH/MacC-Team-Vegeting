//
//  UserProfileViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/11/02.
//

import UIKit
import PhotosUI

final class UserProfileViewController: UIViewController {
    
    private let progressBarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "progress1")
        return imageView
    }()
    
    private let profileMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 사진을 선택해주세요."
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 55
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(hex: "#F2F2F2")
        return imageView
    }()
    
    private let nicknameMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임을 입력해주세요."
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        return textField
    }()
    
    private lazy var nicknameLimitWarningLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureTextField()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupLayout()
    }
    
    func configureTextField() {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: nicknameTextField.frame.size.height-1, width: nicknameTextField.frame.width, height: 1)
        border.backgroundColor = UIColor.label.cgColor
        nicknameTextField.layer.addSublayer(border)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubviews(progressBarImageView, profileMessageLabel, profileImageView, nicknameMessageLabel, nicknameTextField, nicknameLimitWarningLabel, nextButton)
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            progressBarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 116),
            progressBarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBarImageView.widthAnchor.constraint(equalToConstant: 186),
            progressBarImageView.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            profileMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 178),
            profileMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21)
        ])
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: profileMessageLabel.bottomAnchor, constant: 17),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 110),
            profileImageView.widthAnchor.constraint(equalToConstant: 110)
        ])
        
        NSLayoutConstraint.activate([
            nicknameMessageLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 78),
            nicknameMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21)
        ])
        
        NSLayoutConstraint.activate([
            nicknameTextField.topAnchor.constraint(equalTo: nicknameMessageLabel.bottomAnchor, constant: 17),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nicknameTextField.widthAnchor.constraint(equalToConstant: 350),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55)
        ])
        
    }
}
