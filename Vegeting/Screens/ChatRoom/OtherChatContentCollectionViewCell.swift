//
//  ChatRoomContentCollectionViewCell.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/12.
//

import UIKit

enum SenderType: CaseIterable {
    case mine
    case other
    case otherNeedProfile
}

final class OtherChatContentCollectionViewCell: UICollectionViewCell {
    
    private enum SizeLiteral: CGFloat {
        case profileImageSize = 37.0
    }
    
    private var contentLabelTopAnchor: NSLayoutConstraint?
    
    private let backgroundPaddingView: UIView = {
        let view = UIView()
        //        임시 컬러 삽입
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 21
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        //        임시 컬러
        imageView.backgroundColor = .gray.withAlphaComponent(0.5)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = SizeLiteral.profileImageSize.rawValue / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let profileUserNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let contentLabelTopAnchor = contentLabelTopAnchor {
            contentLabelTopAnchor.isActive = false
        }
    }
    
    func configure(with model: MessageBubble) {
        contentLabel.text = model.message.content
        dateTimeLabel.text = model.message.createdAt.toHourAndMinuteString()
        profileUserNameLabel.text = model.message.senderName
        backgroundPaddingView.layer.cornerRadius = model.message.content?.count ?? 0 > 3 ? 21 : 16
        updateLayout(senderType: model.senderType)
    }
    
}

// MARK: Layout 관련 함수
extension OtherChatContentCollectionViewCell {

    private func updateLayout(senderType: SenderType) {
        let hiddenStatus: Bool
        
        switch senderType {
        case .otherNeedProfile:
            hiddenStatus = false
            contentLabelTopAnchor = contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36)
        default:
            hiddenStatus = true
            contentLabelTopAnchor = contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        }
        
        profileImageView.isHidden = hiddenStatus
        profileUserNameLabel.isHidden = hiddenStatus
        contentLabelTopAnchor?.isActive = true
    }
    
    private func configureUI() {
        contentView.addSubviews(backgroundPaddingView, contentLabel, dateTimeLabel)
        contentView.addSubviews(profileImageView, profileUserNameLabel)
    }
    
    private func setupLayout() {
        setupProfileLayout()
        
        let contentLabelConstraints = [
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 78),
            contentLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -66),
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ]
        
        
        let backgroundPaddingViewConstraints = [
            backgroundPaddingView.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor, constant: -16),
            backgroundPaddingView.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor, constant: 16),
            backgroundPaddingView.topAnchor.constraint(equalTo: contentLabel.topAnchor, constant: -12),
            backgroundPaddingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ]
        
        let dateTimeLabelConstraints = [
            dateTimeLabel.leadingAnchor.constraint(equalTo: backgroundPaddingView.trailingAnchor, constant: 8),
            dateTimeLabel.bottomAnchor.constraint(equalTo: backgroundPaddingView.bottomAnchor)
        ]
        
        [contentLabelConstraints, dateTimeLabelConstraints, backgroundPaddingViewConstraints].forEach { constraints in
            NSLayoutConstraint.activate(constraints)
        }
        
    }
    
    private func setupProfileLayout() {
        let profileImageViewConstraints = [
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: SizeLiteral.profileImageSize.rawValue),
            profileImageView.heightAnchor.constraint(equalToConstant: SizeLiteral.profileImageSize.rawValue)
        ]
        
        let profileUserNameLabelConstraints = [
            profileUserNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 4),
            profileUserNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
        ]
        
        [profileImageViewConstraints, profileUserNameLabelConstraints].forEach { constraints in
            NSLayoutConstraint.activate(constraints)
        }
        
        
    }
}
