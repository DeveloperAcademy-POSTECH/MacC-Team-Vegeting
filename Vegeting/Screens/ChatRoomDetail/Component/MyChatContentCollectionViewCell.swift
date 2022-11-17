//
//  MyChatContentCollectionViewCell.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/13.
//

import UIKit

final class MyChatContentCollectionViewCell: UICollectionViewCell {
    
    private let backgroundPaddingView: UIView = {
        let view = UIView()
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 21
        view.layer.borderColor = UIColor.vfGray3.cgColor
        view.layer.borderWidth = 1.5
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: MessageBubble) {
        contentLabel.text = model.message.content
        dateTimeLabel.text = model.message.createdAt.toMessageTimeText()
        
        if let text = model.message.content {
            contentLabel.textAlignment = text.count > 1 ? .left : .center
        }
    }
    
}

// MARK: Layout 관련 함수
extension MyChatContentCollectionViewCell {
    
    private func configureUI() {
        contentView.addSubviews(backgroundPaddingView, contentLabel, dateTimeLabel)
    }
    
    private func setupLayout() {
        
        let contentLabelConstraints = [
            contentLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 111),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36),
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            contentLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 18),
            contentLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18)
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
