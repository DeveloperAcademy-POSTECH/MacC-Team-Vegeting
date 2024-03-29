//
//  MyPageProfileTableViewCell.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/08.
//

import UIKit

protocol MyPageProfileTableViewCellDelegate: AnyObject {
    func profileEditButtonTapped()
}

class MyPageProfileTableViewCell: UITableViewCell {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.bounds.size = .init(width: 60, height: 60)
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let vegetarianStepLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        label.textColor = .systemGray2
        return label
    }()
    
    private lazy var profileEditButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 편집", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.setTitleColor(.gray, for: .normal)
        button.setBackgroundColor(.systemGray5, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 7
        button.addTarget(self, action: #selector(showProfileEditView), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: MyPageProfileTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubviews(profileImageView, labelStackView, profileEditButton)
        labelStackView.addArrangedSubviews(nicknameLabel, vegetarianStepLabel)
        
        profileImageView.constraint(top: contentView.topAnchor,
                                    leading: contentView.leadingAnchor,
                                    bottom: contentView.bottomAnchor,
                                    padding: UIEdgeInsets(top: 22, left: 20, bottom: 22, right: 0))
        profileImageView.constraint(.widthAnchor, constant: 60)
        profileImageView.constraint(.heightAnchor, constant: 60)
        
        labelStackView.constraint(leading: profileImageView.trailingAnchor,
                                  centerY: contentView.centerYAnchor,
                                  padding: UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 0))
        
        profileEditButton.constraint(trailing: contentView.trailingAnchor,
                              centerY: contentView.centerYAnchor,
                              padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20))
        profileEditButton.constraint(.widthAnchor, constant: 79)
        profileEditButton.constraint(.heightAnchor, constant: 33)
    }

   func configure(imageURL: URL?, nickName: String, step: String) {
        profileImageView.setImage(kind: "profile", with: imageURL)
        nicknameLabel.text = nickName
        vegetarianStepLabel.text = step
    }
    
    @objc
    private func showProfileEditView() {
        delegate?.profileEditButtonTapped()
    }
}
