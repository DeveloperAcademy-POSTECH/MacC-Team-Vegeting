//
//  UserTypeIntroductionViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/11/16.
//

import UIKit

final class UserTypeIntroductionViewController: UIViewController {
    
    private let progressBarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "progress4")
        return imageView
    }()
    
    private let vegetarianTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        label.text = "채식단계를 선택해주세요."
        return label
    }()
    
    private let vegetarianTypeTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(hex: "#F2F2F2")
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private let introductionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        label.text = "프로필에 들어갈 한줄 소개를 작성해주세요."
        return label
    }()
    
    private let introductionTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(hex: "#F2F2F2")
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private let introductionCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#8E8E93")
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.text = "0/60"
        return label
    }()
    
    private let nextButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("다음으로", for: .normal)
        button.isEnabled = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupLayout()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubviews(progressBarImageView, vegetarianTypeLabel, vegetarianTypeTextField,
                         introductionLabel, introductionTextField, introductionCountLabel, nextButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            progressBarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 1/10),
            progressBarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBarImageView.widthAnchor.constraint(equalToConstant: 186),
            progressBarImageView.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            vegetarianTypeLabel.topAnchor.constraint(equalTo: progressBarImageView.bottomAnchor, constant: view.frame.height * 1/10),
            vegetarianTypeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            vegetarianTypeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            vegetarianTypeTextField.topAnchor.constraint(equalTo: vegetarianTypeLabel.bottomAnchor, constant: 14),
            vegetarianTypeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            vegetarianTypeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            vegetarianTypeTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            introductionLabel.topAnchor.constraint(equalTo: vegetarianTypeTextField.bottomAnchor, constant: view.frame.height * 1/8),
            introductionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            introductionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            introductionTextField.topAnchor.constraint(equalTo: introductionLabel.bottomAnchor, constant: 14),
            introductionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            introductionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            introductionTextField.heightAnchor.constraint(equalToConstant: view.frame.height * 1/7)
        ])
        
        NSLayoutConstraint.activate([
            introductionCountLabel.topAnchor.constraint(equalTo: introductionTextField.bottomAnchor, constant: 8),
            introductionCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height * 1/25))
        ])
    }
    
}
