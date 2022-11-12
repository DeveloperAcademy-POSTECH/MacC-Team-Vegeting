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
}
class ChatRoomContentCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ChatRoomContentCollectionViewCell"
    
    var contentLabelAnchors: [NSLayoutConstraint]?
    var dateTimeLabelAnchors: [NSLayoutConstraint]?
    
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
        label.lineBreakMode = .byWordWrapping
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRandomLabel() {
        contentLabel.text = randomTestText()
        let senderType = randomTestSenderType()
        
        switch senderType {
        case .mine:
            setupComponentLayoutMine()
        case .other:
            setupComponentLayoutOther()
        }
        configureUI()
        setupLayout()
    }

    private func randomTestSenderType() -> SenderType {
        let randomSenderType = SenderType.allCases.randomElement()!
        return randomSenderType
    }
    
    private func randomTestText() -> String {
        let labelCase = ["감자님이 저번에 말씀하셨던 곳이 거기인가요?", "와 저도 거기 진짜 가보고 싶었는데 ....... 리조또랑 퐁듀가 진짜 맛있고, 피클도 꼭 추가해야 한대요~!!!!", "고구마 함박집 창문동에 담달에 드디어 오픈 한대요!", "타임은 LG 클로이 서브봇을 로보틱스 분야 최고의 발명품으로 꼽았다. 라이다 센서와 3D 카메라를 사용해 혼잡한 공간에서도 안정적으로 주행하고, 66파운드(30kg) 물품을 연속 11시간 운반할 수 있다고 설명했다. 가정용 식물재배기인 LG 틔운은 식물을 잘 키우는 요령이 없는 사람도 집안에서 쉽게 재배할 수 있는 점을 강조했다."]
        let idx = Int.random(in: 0...3)
        return labelCase[idx]
    }
    
}

extension ChatRoomContentCollectionViewCell {
    
    private func setupComponentLayoutMine() {
        contentLabelAnchors = [
            contentLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 160),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -37),
        ]
        
        dateTimeLabelAnchors = [
            dateTimeLabel.trailingAnchor.constraint(equalTo: backgroundPaddingView.leadingAnchor, constant: -8),
        ]
    }
    
    private func setupComponentLayoutOther() {
        
        contentLabelAnchors = [
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 78),
            contentLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -66),
        ]
        
        dateTimeLabelAnchors = [
            dateTimeLabel.leadingAnchor.constraint(equalTo: backgroundPaddingView.trailingAnchor, constant: 8),
        ]
    }
    
    private func configureUI() {
        contentView.addSubviews(backgroundPaddingView, contentLabel, dateTimeLabel)
    }
    
    private func setupLayout() {
        guard let contentLabelAnchors = contentLabelAnchors, let dateTimeLabelAnchors = dateTimeLabelAnchors else { return }
        let contentLabelConstraints = [
//            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 78),
//            contentLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -66),
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ]
        
        
        let backgroundPaddingViewConstraints = [
            backgroundPaddingView.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor, constant: -16),
            backgroundPaddingView.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor, constant: 16),
            backgroundPaddingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundPaddingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ]
        
        let dateTimeLabelConstraints = [
//            dateTimeLabel.leadingAnchor.constraint(equalTo: backgroundPaddingView.trailingAnchor, constant: 8),
            dateTimeLabel.bottomAnchor.constraint(equalTo: backgroundPaddingView.bottomAnchor)
        ]
        
        [contentLabelAnchors, contentLabelConstraints, dateTimeLabelAnchors, dateTimeLabelConstraints, backgroundPaddingViewConstraints].forEach { constraints in
            NSLayoutConstraint.activate(constraints)
        }
        
    }
    
}
