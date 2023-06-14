//
//  MyPageTableViewCell.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/08.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubviews(label, separatorView)
        label.constraint(top: contentView.topAnchor,
                         leading: contentView.leadingAnchor,
                         bottom: contentView.bottomAnchor,
                         padding: UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 0))
        
        separatorView.constraint(top: contentView.topAnchor,
                                 leading: contentView.leadingAnchor,
                                 trailing: contentView.trailingAnchor,
                                 padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        separatorView.constraint(.heightAnchor, constant: 1)
    }
    
    func configure(with data: MyPageSettingElement) {
        label.text = data.text
        
        if !data.isSmallTitle {
            label.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .regular))
            separatorView.removeFromSuperview()
        }
    }
}
