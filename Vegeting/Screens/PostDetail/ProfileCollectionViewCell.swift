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

struct ParticipantsInfo {
    let profileImage: UIImage!
    let participantsName: String
}

class ProfileCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAddSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = (Constants.profileImageSize - Constants.spacing * 2) / 2.0
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let participantsName: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func configureAddSubviews() {
        contentView.addSubviews(profileImage, participantsName)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.spacing),
            profileImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.spacing),
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.spacing),
            profileImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.spacing)
        ])
        
        NSLayoutConstraint.activate([
            participantsName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 5),
            participantsName.widthAnchor.constraint(equalToConstant: Constants.profileImageSize)
        ])
    }
    
    func configure(with data: ParticipantsInfo) {
        profileImage.image = data.profileImage
        participantsName.text = data.participantsName
    }
}
