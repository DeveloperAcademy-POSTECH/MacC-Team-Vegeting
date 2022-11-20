//
//  UserInterestViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/06.
//

import UIKit

class UserInterestViewController: UIViewController {

    private let progressBarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "progress5")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        label.text = "관심있는 모임을 선택해주세요. (최대 3개)"
        return label
    }()
        
    private lazy var profileRegisterButton: BottomButton = {
       let button = BottomButton()
        button.setTitle("프로필 설정 완료", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(profileRegisterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let interestList: [String] = ["맛집", "카페", "행사", "패션", "뷰티", "환경", "정치", "친목", "동물권", "요리", "베이킹"]
    private lazy var selectInterestView = InterestView(interestList: interestList, entryPoint: .register)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupLayout()
        configureUI()
    }
    
    private func setupDelegate() {
        selectInterestView.delegate = self
    }
    
    private func setupLayout() {
        view.addSubviews(progressBarImageView,
                         titleLabel,
                         selectInterestView,
                         profileRegisterButton)
        
        progressBarImageView.constraint(top: view.topAnchor,
                                        leading: view.leadingAnchor,
                                        padding: UIEdgeInsets(top: 116, left: 20, bottom: 0, right: 0))
        progressBarImageView.constraint(.widthAnchor, constant: 186)
        progressBarImageView.constraint(.heightAnchor, constant: 26)
        
        titleLabel.constraint(top: progressBarImageView.bottomAnchor,
                              leading: view.leadingAnchor,
                              padding: UIEdgeInsets(top: 38, left: 20, bottom: 0, right: 0))
        
        selectInterestView.constraint(top: titleLabel.bottomAnchor,
                                      leading: view.leadingAnchor,
                                      bottom: profileRegisterButton.topAnchor,
                                      trailing: view.trailingAnchor,
                                      padding: UIEdgeInsets(top: 11, left: 20, bottom: 10, right: 20))
        
        profileRegisterButton.constraint(bottom: view.bottomAnchor,
                                centerX: view.centerXAnchor,
                                padding: UIEdgeInsets(top: 0, left: 0, bottom: 55, right: 0))
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    @objc
    private func profileRegisterButtonTapped() {
        // TODO: 프로필 register 함수 구현
    }
}

extension UserInterestViewController: InterestViewDelegate {
    
    func setBottomButtonEnabled(selectedList: [String]) {
        if selectedList.isEmpty {
            profileRegisterButton.isEnabled = false
        } else {
            profileRegisterButton.isEnabled = true
        }
    }

}
