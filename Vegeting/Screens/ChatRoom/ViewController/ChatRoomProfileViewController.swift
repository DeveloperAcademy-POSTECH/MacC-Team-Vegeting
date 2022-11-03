//
//  ChatRoomProfileViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/03.
//

import UIKit

class ChatRoomProfileViewController: UIViewController {
    
    private let reportButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "verticalEllipsis"), for: .normal)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 51.5
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let vegetarianStepLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .regular))
        label.textColor = .systemGray2
        return label
    }()
    
    private let ageGroupLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        return label
    }()
    
    private let selfIntroductionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .regular))
        return label
    }()
    
    private let interestCollectionView = InterestView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
    }
    
    private func setupLayout() {
        view.addSubviews()
     
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
}
