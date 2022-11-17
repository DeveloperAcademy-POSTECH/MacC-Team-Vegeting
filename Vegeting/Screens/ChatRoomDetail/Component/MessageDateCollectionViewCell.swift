//
//  MessageDateCollectionViewCell.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/17.
//

import UIKit

class MessageDateCollectionViewCell: UICollectionViewCell {
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.text = "2022년 9월 13일"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Layout 구성 함수
extension MessageDateCollectionViewCell {
    private func setupLayout() {
        contentView.addSubviews(dateLabel)
        let dateLabelConstraints = [
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        NSLayoutConstraint.activate(dateLabelConstraints)
    }
}
