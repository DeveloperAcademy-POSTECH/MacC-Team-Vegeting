//
//  ProfileVIew.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/09.
//

import UIKit

final class ProfileView: UIView {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 51.5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
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
        stackView.spacing = 3
        stackView.distribution = .fill
        return stackView
    }()
    
    private let dividerLabel1: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        label.textColor = .systemGray2
        label.text = "·"
        return label
    }()
    
    private let dividerLabel2: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        label.textColor = .systemGray2
        label.text = "·"
        return label
    }()
    
    private let ageGroupLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        label.textColor = .systemGray2
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        label.textColor = .systemGray2
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        label.textColor = .systemGray2
        return label
    }()
    
    private let selfIntroductionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private let interestCollectionView = InterestView(interestList: ["맛집", "요리", "동물권"], entryPoint: .profile)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubviews(profileImageView,
                    profileStackView,
                    nicknameLabel,
                    vegetarianStepLabel,
                    informationStackView,
                    selfIntroductionLabel,
                    interestCollectionView)
        
        profileImageView.constraint(top: self.topAnchor,
                                    leading: self.leadingAnchor,
                                    padding: UIEdgeInsets(top: 25, left: 30, bottom: 0, right: 0))
        profileImageView.constraint(.widthAnchor, constant: 103)
        profileImageView.constraint(.heightAnchor, constant: 103)
        
        
        profileStackView.addArrangedSubviews(nicknameLabel, vegetarianStepLabel)
        profileStackView.constraint(top: profileImageView.topAnchor,
                                    leading: profileImageView.trailingAnchor,
                                    padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 0))
        
        informationStackView.addArrangedSubviews(ageGroupLabel, dividerLabel1, genderLabel, dividerLabel2, locationLabel)
        informationStackView.constraint(top: profileStackView.bottomAnchor,
                                        leading: profileImageView.trailingAnchor,
                                        padding: UIEdgeInsets(top: 13, left: 20, bottom: 0, right: 0))
        
        selfIntroductionLabel.constraint(top: informationStackView.bottomAnchor,
                                         leading: self.leadingAnchor,
                                         trailing: self.trailingAnchor,
                                         padding: UIEdgeInsets(top: 31, left: 30, bottom: 0, right: 30))
        
        interestCollectionView.constraint(top: selfIntroductionLabel.bottomAnchor,
                                          leading: self.leadingAnchor,
                                          bottom: self.bottomAnchor,
                                          trailing: self.trailingAnchor,
                                          padding: UIEdgeInsets(top: UIScreen().hasNotch ? 35 : 15, left: 30, bottom: 0, right: 30))
        interestCollectionView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    private func configureUI() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 24
    }
    
    func configure(with data: Participant) {
        profileImageView.setImage(kind: "profile", with: data.profileImageURL)
        nicknameLabel.text = data.name
        vegetarianStepLabel.text = data.vegetarianType
        ageGroupLabel.text = data.birth?.toAgeGroup()
        locationLabel.text = data.location
        genderLabel.text = data.gender
        selfIntroductionLabel.text = data.introduction
        interestCollectionView.changeCategoryList(with: data.interests ?? [])
        
    }
}

