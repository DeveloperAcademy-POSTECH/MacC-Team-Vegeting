//
//  ProfileCollectionViewCell.swift
//  Vegeting
//
//  Created by 김원희 on 2022/10/26.
//
import UIKit

private enum Constants {
    static let profileImageSize = 80.0
    static let profileImageCGSize = CGSize(width: Constants.profileImageSize, height: Constants.profileImageSize)
    static let borderWidth = 2.0
    static let spacing = 4.0
}

class ProfileCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAddSubViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = (Constants.profileImageSize - Constants.spacing * 2) / 2.0
        image.clipsToBounds = true
        return image
    }()
    
    private let nameStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()
    
    private let participantsName: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        return label
    }()
    
    private let hostLabel: UILabel = {
        let label = UILabel()
        label.text = "주최자"
        label.textColor = .vfGray2
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    func configureAddSubViews() {
        contentView.addSubviews(profileImage, nameStackView)
        nameStackView.addArrangedSubview(participantsName)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.spacing),
            profileImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.spacing),
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.spacing),
            profileImage.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            nameStackView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 15),
            nameStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func configure(with data: ParticipantsInfo) {
        profileImage.image = data.profileImage
        participantsName.text = data.participantsName
        if data.isHost {
            nameStackView.addArrangedSubview(hostLabel)
        }
    }
}
