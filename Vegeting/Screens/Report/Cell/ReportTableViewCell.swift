//
//  ReportTableViewCell.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/17.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    
    // MARK: - properties
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        return button
    }()
    
    private let reportLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubviews(checkButton, reportLabel)
        checkButton.constraint(top: contentView.topAnchor,
                               leading: contentView.leadingAnchor,
                               bottom: contentView.bottomAnchor,
                               padding: UIEdgeInsets(top: 10.5, left: 22, bottom: 10.5, right: 0))
        checkButton.constraint(.widthAnchor, constant: 22)
        checkButton.constraint(.heightAnchor, constant: 22)
        
        reportLabel.constraint(top: contentView.topAnchor,
                               leading: checkButton.trailingAnchor,
                               bottom: contentView.bottomAnchor,
                               trailing: contentView.trailingAnchor,
                               padding: UIEdgeInsets(top: 10.5, left: 18, bottom: 10.5, right: 22))
        
    }
    
    func configure(with reportText: String) {
        reportLabel.text = reportText
    }
    
}
