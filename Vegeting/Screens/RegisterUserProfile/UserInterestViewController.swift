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
    
    private let selectInterestView = InterestView(interestList: ["맛집 탐방", "동물권 공부", "요리", "행사 참가", "친목"])

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
    }
    
    private func setupLayout() {
        view.addSubviews(progressBarImageView, titleLabel, selectInterestView)
        
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
                                      trailing: view.trailingAnchor,
                                      padding: UIEdgeInsets(top: 11, left: 20, bottom: 0, right: 20))
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
}
