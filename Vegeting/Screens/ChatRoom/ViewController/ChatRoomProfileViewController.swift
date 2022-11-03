//
//  ChatRoomProfileViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/03.
//

import UIKit

struct ModalModel {
    let image: UIImage = UIImage(named: "coverImage") ?? UIImage()
    let nickname: String
    let vegetarianStep: String
    let ageGroup: String
    let location: String
    let gender: String
    let introduction: String
}

class ChatRoomProfileViewController: UIViewController {
    
    // MARK: - properties
    
    private lazy var reportButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "verticalEllipsis"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.bounds.size = .init(width: 103, height: 103)
        return imageView
    }()
    
    private let profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 9
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let vegetarianStepLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .regular))
        label.textColor = .systemGray2
        return label
    }()
    
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.distribution = .fill
        return stackView
    }()
    
    private let divierView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    private let divierView2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    private let ageGroupLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        return label
    }()
    
    private let selfIntroductionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private let interestCollectionView = InterestView()
    
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
    }
    
    // MARK: - func
    
    private func setupLayout() {
        view.addSubviews(reportButton,
                         profileImageView,
                         profileStackView,
                         nicknameLabel,
                         vegetarianStepLabel,
                         informationStackView,
                         selfIntroductionLabel,
                         interestCollectionView)
        
        reportButton.constraint(top: view.topAnchor,
                                trailing: view.trailingAnchor,
                                padding: UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 24))
        reportButton.constraint(.widthAnchor, constant: 30)
        reportButton.constraint(.heightAnchor, constant: 30)
        
        profileImageView.constraint(top: reportButton.bottomAnchor,
                                    leading: view.leadingAnchor,
                                    padding: UIEdgeInsets(top: 5, left: 30, bottom: 0, right: 0))
        profileImageView.constraint(.widthAnchor, constant: 103)
        profileImageView.constraint(.heightAnchor, constant: 103)
        
        
        profileStackView.addArrangedSubviews(nicknameLabel, vegetarianStepLabel)
        profileStackView.constraint(top: reportButton.bottomAnchor,
                                    leading: profileImageView.trailingAnchor,
                                    padding: UIEdgeInsets(top: 40, left: 20, bottom: 0, right: 0))
        
        informationStackView.addArrangedSubviews(ageGroupLabel, divierView, locationLabel, divierView2, genderLabel)
        informationStackView.constraint(top: profileImageView.bottomAnchor,
                                        centerX: view.centerXAnchor,
                                        padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        
        divierView.constraint(.widthAnchor, constant: 1)
        divierView.constraint(.heightAnchor, constant: 18.5)
        divierView2.constraint(.widthAnchor, constant: 1)
        divierView2.constraint(.heightAnchor, constant: 18.5)
        
        selfIntroductionLabel.constraint(top: informationStackView.bottomAnchor,
                                         leading: view.leadingAnchor,
                                         trailing: view.trailingAnchor,
                                         padding: UIEdgeInsets(top: 31, left: 30, bottom: 0, right: 30))
        
        interestCollectionView.constraint(top: selfIntroductionLabel.bottomAnchor,
                                          leading: view.leadingAnchor,
                                          trailing: view.trailingAnchor,
                                          padding: UIEdgeInsets(top: UIScreen().hasNotch ? 35 : 15, left: 30, bottom: 0, right: 30))
        
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.height / 2
        print(profileImageView.bounds.size.height / 2)
    }
    
    @objc
    private func showActionSheet() {
        print("하하이")
        let alert = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "게시글 신고", style: .default) { action in
            //
        }
        
        let userBlockAction = UIAlertAction(title: "작성자 차단", style: .default) { action in
            //
        }
        
        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel) { action in
            //
        }
        
        [reportAction, userBlockAction, cancelAlertAction].forEach { action in
            alert.addAction(action)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func configure(with data: ModalModel) {
        profileImageView.image = data.image
        nicknameLabel.text = data.nickname
        vegetarianStepLabel.text = data.vegetarianStep
        ageGroupLabel.text = data.ageGroup
        locationLabel.text = data.location
        genderLabel.text = data.gender
        selfIntroductionLabel.text = data.introduction
    }
}
