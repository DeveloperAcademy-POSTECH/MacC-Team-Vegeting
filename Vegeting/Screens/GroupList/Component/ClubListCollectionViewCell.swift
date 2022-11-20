//
//  GroupListCell.swift
//  Vegeting
//
//  Created by kelly on 2022/10/26.
//

import UIKit

final class ClubListCollectionViewCell: UICollectionViewCell {
    private lazy var categoryView: CategoryView = {
        let categoryView = CategoryView()
        return categoryView
    }()
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.tintColor = .black
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private lazy var placeLabelWithImage: LabelWithImageStackView = {
        let placeLabel = LabelWithImageStackView()
        let imageConfig = UIImage.SymbolConfiguration.init(pointSize: 14, weight: .light)
        placeLabel.setCoverImage(image: UIImage(systemName: "mappin", withConfiguration: imageConfig))
        return placeLabel
    }()
    
    private lazy var countLabelWithImage: LabelWithImageStackView = {
        let countLabel = LabelWithImageStackView()
        let imageConfig = UIImage.SymbolConfiguration.init(pointSize: 17, weight: .light)
        countLabel.setCoverImage(image: UIImage(systemName: "person", withConfiguration: imageConfig))
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
        addSubviews(coverImageView, categoryView, titleLabel, placeLabelWithImage, countLabelWithImage)
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: self.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 87)
        ])
        
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: coverImageView.topAnchor, constant: 8),
            categoryView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor, constant: 8),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            placeLabelWithImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            placeLabelWithImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            placeLabelWithImage.bottomAnchor.constraint(equalTo: countLabelWithImage.topAnchor, constant: -7)
        ])
        
        NSLayoutConstraint.activate([
            countLabelWithImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            countLabelWithImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabelWithImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -9)
        ])
    }
    
    private func configureUI() {
        clipsToBounds = true
        self.layer.cornerRadius = 12
        backgroundColor = .vfGray4
    }
    
    func configure(with item: Club) {
        coverImageView.image = UIImage(named: item.coverImageURL ?? "groupCoverImage1")
        categoryView.configure(text: item.clubCategory ?? "", backgroundColor: .vfGray4 )
        titleLabel.text = item.clubTitle
        placeLabelWithImage.setLabelText(text: "서울시 동작구")
        let participantsCount = item.participants?.count ?? 0
        countLabelWithImage.setLabelText(text: "\(participantsCount)/\(item.maxNumberOfPeople)")
    }
}
