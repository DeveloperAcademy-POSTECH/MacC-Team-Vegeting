//
//  DateInChatDividerCollectionReusableView.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/13.
//

import UIKit

class DateInChatDividerCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "DateInChatDividerCollectionReusableView"
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2023년 9월 8일"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .red
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
}

extension DateInChatDividerCollectionReusableView {
    
    private func configureUI() {
        addSubviews(dateLabel)
    }
    
    private func setupLayout() {
        let dateLabelConstraints = [
            dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(dateLabelConstraints)
    }
}
