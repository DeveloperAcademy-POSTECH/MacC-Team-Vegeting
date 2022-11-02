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
        imageView.layer.masksToBounds = true
        imageView.layer.bounds.size = .init(width: 70, height: 70)
        return imageView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 27
        return stackView
    }()
    
    private let leftContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        return stackView
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
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
    
    private let paddingView: UIView = UIView()
    
    private let latestChatLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        return label
    }()
    
    private let rightContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .equalSpacing
        stackView.alignment = .trailing
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
        view.layer.bounds.size = .init(width: 22, height: 22)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupLayout() {
        contentView.addSubviews(roomImageView,
                                contentStackView)
        roomImageView.constraint(top: contentView.topAnchor,
                                 leading: contentView.leadingAnchor,
                                 bottom: contentView.bottomAnchor,
                                 padding: UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 0))
        roomImageView.constraint(.widthAnchor, constant: 70)
        roomImageView.constraint(.heightAnchor, constant: 70)
        
        contentStackView.addArrangedSubviews(leftContentStackView, rightContentStackView)
        contentStackView.constraint(leading: roomImageView.trailingAnchor,
                                 trailing: contentView.trailingAnchor,
                                 centerY: contentView.centerYAnchor,
                                 padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20))
        
        leftContentStackView.addArrangedSubviews(titleStackView, latestChatLabel)
        titleStackView.addArrangedSubviews(titleLabel, currentUserCountLabel, paddingView)
        rightContentStackView.addArrangedSubviews(backgroundUnreadChatView, latestChatDateLabel)
        
        backgroundUnreadChatView.constraint(.widthAnchor, constant: 22)
        backgroundUnreadChatView.constraint(.heightAnchor, constant: 22)
        
        backgroundUnreadChatView.addSubview(unreadChatCountLabel)
        unreadChatCountLabel.constraint(centerX: backgroundUnreadChatView.centerXAnchor,
                                        centerY: backgroundUnreadChatView.centerYAnchor)
        
        latestChatDateLabel.setContentCompressionResistancePriority(.init(rawValue: 751), for: .horizontal)
    }
    
    func configure(with data: TempChatModel) {
        roomImageView.image = UIImage(named: data.imageName)
        titleLabel.text = data.title
        currentUserCountLabel.text = data.currentNumer.description
        latestChatLabel.text = data.latestChat
        latestChatDateLabel.text = data.latestChatDate.toString(format: "mm:SS")
        unreadChatCountLabel.text = data.unreadChatCount.description
    }
    
    func configureUI() {
        roomImageView.layer.cornerRadius = roomImageView.bounds.size.height / 2
        backgroundUnreadChatView.layer.cornerRadius = backgroundUnreadChatView.bounds.size.height / 2
    }
}
