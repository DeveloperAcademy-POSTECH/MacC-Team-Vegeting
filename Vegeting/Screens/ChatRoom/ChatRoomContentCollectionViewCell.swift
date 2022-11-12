//
//  ChatRoomContentCollectionViewCell.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/12.
//

import UIKit

class ChatRoomContentCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ChatRoomContentCollectionViewCell"
    
//    private let contentLabel: PaddingLabel = {
//        let label = PaddingLabel(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
//        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 0
//        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        label.layer.masksToBounds = true
//        label.layer.cornerRadius = 14
//        label.layer.backgroundColor = UIColor.gray.cgColor
//        return label
//    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.layer.cornerRadius = 14
        label.layer.borderColor = UIColor.gray.cgColor
        return label
    }()
    
    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "12:24"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.layer.cornerRadius = 14
        return label
    }()
    
    private let backgroundPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 14
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setupLayout()
        
        setRandomLabel()
        
    }
    
    private func setRandomLabel() {
        let labelCase = ["감자님이 저번에 말씀하셨던 곳이 거기인가요?", "와 저도 거기 진짜 가보고 싶었는데 ....... 리조또랑 퐁듀가 진짜 맛있고, 피클도 꼭 추가해야 한대요~!!!!", "고구마 함박집 창문동에 담달에 드디어 오픈 한대요!", "타임은 LG 클로이 서브봇을 로보틱스 분야 최고의 발명품으로 꼽았다. 라이다 센서와 3D 카메라를 사용해 혼잡한 공간에서도 안정적으로 주행하고, 66파운드(30kg) 물품을 연속 11시간 운반할 수 있다고 설명했다. 가정용 식물재배기인 LG 틔운은 식물을 잘 키우는 요령이 없는 사람도 집안에서 쉽게 재배할 수 있는 점을 강조했다."]
        let idx = Int.random(in: 0...3)
        contentLabel.text = labelCase[idx]
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        contentView.addSubviews(backgroundPaddingView, contentLabel, dateTimeLabel)
    }
    private func setupLayout() {
        let contentLabelConstraints = [
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 78),
            contentLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -66),
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
            dateTimeLabel.leadingAnchor.constraint(equalTo: backgroundPaddingView.trailingAnchor, constant: 8),
            dateTimeLabel.bottomAnchor.constraint(equalTo: backgroundPaddingView.bottomAnchor)
        ]
        
        [contentLabelConstraints, dateTimeLabelConstraints, backgroundPaddingViewConstraints].forEach { constraints in
            NSLayoutConstraint.activate(constraints)
        }
    
    }
    
}
