//
//  GroupListCell.swift
//  Vegeting
//
//  Created by kelly on 2022/10/26.
//

import UIKit

final class ClubListCollectionViewCell: UICollectionViewCell {
    private lazy var coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.tintColor = .black
        return label
    }()
    
    private lazy var placeLabelWithImage: LabelWithImage = {
        let placeLabel = LabelWithImage()
        placeLabel.imageName = "pin"
        return placeLabel
    }()
    
    private lazy var countLabelWithImage: LabelWithImage = {
        let countLabel = LabelWithImage()
        countLabel.imageName = "person"
        return countLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        [coverImage, titleLabel, placeLabelWithImage, countLabelWithImage].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: self.topAnchor),
            coverImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            coverImage.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            placeLabelWithImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            placeLabelWithImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            placeLabelWithImage.bottomAnchor.constraint(equalTo: countLabelWithImage.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            countLabelWithImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            countLabelWithImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabelWithImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    private func configureUI() {
        clipsToBounds = true
        self.layer.cornerRadius = 12
    }
    
    func configure(with item: Club) {
        coverImage.image = UIImage(systemName: "star")
        coverImage.backgroundColor = .gray
        titleLabel.text = item.clubTitle
        placeLabelWithImage.labelText = "place"
        let participantsCount = item.participants?.count ?? 0
        countLabelWithImage.labelText = "\(participantsCount)/\(item.maxNumberOfPeople)"
    }
}
