//
//  ReportTableViewHeaderView.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/18.
//

import UIKit

final class ReportTableViewHeaderView: UITableViewHeaderFooterView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.constraint(top: contentView.topAnchor,
                              leading: contentView.leadingAnchor,
                              bottom: contentView.bottomAnchor,
                              trailing: contentView.trailingAnchor,
                              padding: UIEdgeInsets(top: 10.5, left: 20, bottom: 10.5, right: 20))
    }
    
    func configure(with titleText: String) {
        titleLabel.text = titleText
    }
}
