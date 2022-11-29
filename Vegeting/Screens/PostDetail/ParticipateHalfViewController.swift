//
//  ParticipateHalfViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/29.
//

import UIKit

final class ParticipateHalfViewController: UIViewController {

    // MARK: - properties
    
    private let contentView = UIView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "participateImage")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        label.text = "채팅방에 입장하시겠습니까?"
        return label
    }()
    
    private let subTitleLabel: UILabel = {
       let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.text = "채팅방에 입장하면 모임 참석이 확정되고 모임에 대한 자세한 이야기를 나눌 수 있어요."
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private let participateButton: BottomButton = {
       let button = BottomButton()
        button.setTitle("참여하기", for: .normal)
        return button
    }()
    
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
    }
    
    // MARK: - func
    
    private func setupLayout() {
        view.addSubviews(contentView)
        contentView.addSubviews(imageView, titleLabel, subTitleLabel, participateButton)
        
        contentView.constraint(leading: view.leadingAnchor,
                               trailing: view.trailingAnchor)
        NSLayoutConstraint(item: view as Any,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: contentView,
                           attribute: .centerY,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        
        imageView.constraint(top: contentView.topAnchor,
                             centerX: contentView.centerXAnchor)
        imageView.constraint(.widthAnchor, constant: 138)
        imageView.constraint(.heightAnchor, constant: 134)
        
        titleLabel.constraint(top: imageView.bottomAnchor,
                              leading: contentView.leadingAnchor,
                              padding: UIEdgeInsets(top: 39, left: 20, bottom: 0, right: 0))
        
        subTitleLabel.constraint(top: titleLabel.bottomAnchor,
                                 leading: contentView.leadingAnchor,
                                 trailing: contentView.trailingAnchor,
                                 padding: UIEdgeInsets(top: 7, left: 20, bottom: 0, right: 20))
        
        participateButton.constraint(top: subTitleLabel.bottomAnchor,
                                     bottom: contentView.bottomAnchor, centerX: contentView.centerXAnchor,
                                     padding: UIEdgeInsets(top: 25, left: 20, bottom: 0, right: 0))
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 24
    }
}
