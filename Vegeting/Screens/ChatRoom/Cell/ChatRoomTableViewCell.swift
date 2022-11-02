//
//  ChatRoomTableViewCell.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/02.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
    
    private let roomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "coverImage")
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        return imageView
    }()
    
    private let centerLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        return stackView
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setHorizontalStack()
        stackView.spacing = 7
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let currentUserCountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .regular))
        return label
    }()
    
    private let latestChatLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        return label
    }()
    
    private let rightLabelStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let latestChatDateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote, compatibleWith: .init(legibilityWeight: .regular))
        return label
    }()
    
    private let unreadChatCountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote, compatibleWith: .init(legibilityWeight: .regular))
        return label
    }()
    
    private let backgroundUnreadChatView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = view.bounds.height / 2
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupLayout() {
        addSubviews(roomImageView,
                    centerLabelStackView,
                    rightLabelStackView)
        
        roomImageView.constraint(leading: self.leadingAnchor,
                                 centerY: self.centerYAnchor)
        roomImageView.constraint(.widthAnchor, constant: 70)
        roomImageView.constraint(.heightAnchor, constant: 70)
        
        centerLabelStackView.addArrangedSubviews(titleStackView, latestChatLabel)
        centerLabelStackView.constraint(leading: roomImageView.trailingAnchor,
                                        trailing: rightLabelStackView.leadingAnchor,
                                        centerY: self.centerYAnchor,
                                        padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 24))
        
        rightLabelStackView.addArrangedSubviews(backgroundUnreadChatView, latestChatDateLabel)
        
        rightLabelStackView.constraint(trailing: self.trailingAnchor,
                                       centerY: self.centerYAnchor)
        rightLabelStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        backgroundUnreadChatView.constraint(.widthAnchor, constant: 22)
        backgroundUnreadChatView.constraint(.heightAnchor, constant: 22)
        
        backgroundUnreadChatView.addSubview(unreadChatCountLabel)
        unreadChatCountLabel.constraint(centerX: backgroundUnreadChatView.centerXAnchor,
                                        centerY: backgroundUnreadChatView.centerYAnchor)
    }
    
}
