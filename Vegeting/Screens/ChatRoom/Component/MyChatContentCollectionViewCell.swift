//
//  MyChatContentCollectionViewCell.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/13.
//

import UIKit

class MyChatContentCollectionViewCell: UICollectionViewCell {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: TemporaryMessage) {
        contentLabel.text = model.messageContent
    }
    
}

// MARK: Layout 관련 함수
extension MyChatContentCollectionViewCell {
    
    private func configureUI() {
        contentView.addSubviews(backgroundPaddingView, contentLabel, dateTimeLabel)
    }
    
    private func setupLayout() {
        
        let contentLabelConstraints = [
            contentLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 160),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -37),
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
            dateTimeLabel.trailingAnchor.constraint(equalTo: backgroundPaddingView.leadingAnchor, constant: -8),
            dateTimeLabel.bottomAnchor.constraint(equalTo: backgroundPaddingView.bottomAnchor)
        ]
        
        [contentLabelConstraints, dateTimeLabelConstraints, backgroundPaddingViewConstraints].forEach { constraints in
            NSLayoutConstraint.activate(constraints)
        }
        
    }

}


