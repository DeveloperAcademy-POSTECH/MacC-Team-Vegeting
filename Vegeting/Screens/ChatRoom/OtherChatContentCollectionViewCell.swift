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


class OtherChatContentCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "OtherChatContentCollectionViewCell"
        
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
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "12:24"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
        label.text = "초보 채식인"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
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
    
    func configure() {
        contentLabel.text = randomContentText()
        profileUserNameLabel.text = randomUserNameText()
        let senderType = randomTestSenderType()
        
        updateLayout(senderType: senderType)
    }
    
}

// MARK: 채팅방 데이터를 위한 임시 함수
extension OtherChatContentCollectionViewCell {
    private func randomTestSenderType() -> SenderType {
        let randomSenderType = SenderType.allCases.randomElement()!
        return randomSenderType
    }
    
    private func randomContentText() -> String {
        let labelCase = ["감자님이 저번에 말씀하셨던 곳이 거기인가요?", "와 저도 거기 진짜 가보고 싶었는데 ....... 리조또랑 퐁듀가 진짜 맛있고, 피클도 꼭 추가해야 한대요~!!!!", "고구마 함박집 창문동에 담달에 드디어 오픈 한대요!", "타임은 LG 클로이 서브봇을 로보틱스 분야 최고의 발명품으로 꼽았다. 라이다 센서와 3D 카메라를 사용해 혼잡한 공간에서도 안정적으로 주행하고, 66파운드(30kg) 물품을 연속 11시간 운반할 수 있다고 설명했다. 가정용 식물재배기인 LG 틔운은 식물을 잘 키우는 요령이 없는 사람도 집안에서 쉽게 재배할 수 있는 점을 강조했다."]
        let idx = Int.random(in: 0...3)
        return labelCase[idx]
    }
    
    private func randomUserNameText() -> String {
        let labelCase = ["채식쪼아", "채식의 마술사", "채식없인 못살아"]
        let idx = Int.random(in: 0...2)
        return labelCase[idx]
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
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ]
        
        
        let backgroundPaddingViewConstraints = [
            backgroundPaddingView.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor, constant: -16),
            backgroundPaddingView.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor, constant: 16),
            backgroundPaddingView.topAnchor.constraint(equalTo: contentLabel.topAnchor, constant: -8),
            backgroundPaddingView.bottomAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8)
            
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
