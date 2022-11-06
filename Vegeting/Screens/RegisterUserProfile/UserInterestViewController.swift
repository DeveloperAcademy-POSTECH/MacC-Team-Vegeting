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
        
    private lazy var bottomButton: UIButton = {
       let button = BottomButton()
        button.setTitle("프로필 설정 완료", for: .normal)
        button.isEnabled = false
        button.setBackgroundColor(.systemGray, for: .disabled)
        button.setBackgroundColor(.black, for: .normal)
        button.addTarget(self, action: #selector(makeProfile), for: .touchUpInside)
        return button
    }()
    
    private let selectInterestView = InterestView(interestList: ["맛집", "동물권", "요리", "행사 참가", "친목"], entryPoint: .register)
    
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
                         bottomButton)
        
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
                                      padding: UIEdgeInsets(top: 11, left: 20, bottom: 0, right: 0))
        
        bottomButton.constraint(bottom: view.bottomAnchor,
                                centerX: view.centerXAnchor,
                                padding: UIEdgeInsets(top: 0, left: 0, bottom: 55, right: 0))
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    @objc
    private func makeProfile() {
        print("생성됨")
    }
}

extension UserInterestViewController: InterestViewDelegate {
    
    func setBottomButtonEnabled(selectedList: [String]) {
        if selectedList.isEmpty {
            bottomButton.isEnabled = false
        } else {
            bottomButton.isEnabled = true
        }
    }

}
