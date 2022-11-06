//
//  UserGenderBirthViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/11/06.
//

import UIKit

class UserGenderBirthViewController: UIViewController {
    
    private let progressBarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "progress3")
        return imageView
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        label.text = "성별을 알려주세요."
        return label
    }()
    
    private let femaleButton: UIButton = {
        let button = UIButton()
        button.setTitle("여성", for: .normal)
        button.setTitleColor(UIColor(hex: "#616161"), for: .normal)
        button.backgroundColor = UIColor(hex: "#F2F2F2")
        button.layer.cornerRadius = 18.5
        return button
    }()
    
    private let maleButton: UIButton = {
        let button = UIButton()
        button.setTitle("남성", for: .normal)
        button.setTitleColor(UIColor(hex: "#616161"), for: .normal)
        button.backgroundColor = UIColor(hex: "#F2F2F2")
        button.layer.cornerRadius = 18.5
        return button
    }()
    
    private let birthLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        label.text = "출생년도를 알려주세요."
        return label
    }()
    
    private let birthNoticeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = UIColor(hex: "#6C6C70")
        label.text = "출생년도는 프로필에 공개되지 않습니다.\n프로필에 다음과 같이 표기될 목적으로 수집합니다.\n(예 - 10대, 20대, 30대 등)"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupLayout()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubviews(progressBarImageView, genderLabel, femaleButton, maleButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            progressBarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 116),
            progressBarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBarImageView.widthAnchor.constraint(equalToConstant: 186),
            progressBarImageView.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            genderLabel.topAnchor.constraint(equalTo: progressBarImageView.bottomAnchor, constant: 43),
            genderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            femaleButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 15),
            femaleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            femaleButton.widthAnchor.constraint(equalToConstant: 76),
            femaleButton.heightAnchor.constraint(equalToConstant: 37)
        ])
        
        NSLayoutConstraint.activate([
            maleButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 15),
            maleButton.leadingAnchor.constraint(equalTo: femaleButton.trailingAnchor, constant: 12),
            maleButton.widthAnchor.constraint(equalToConstant: 76),
            maleButton.heightAnchor.constraint(equalToConstant: 37)
        ])
    }
}
