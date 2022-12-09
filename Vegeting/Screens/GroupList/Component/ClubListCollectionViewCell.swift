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
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.vfGray4.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var invalidLabel: UILabel = {
        let labelView = UILabel()
        labelView.clipsToBounds = true
        labelView.layer.cornerRadius = 8
        labelView.textAlignment = .center
        labelView.textColor = .vfYellow1
        labelView.backgroundColor = UIColor(hex: "#000000", alpha: 0.6 )
        labelView.text = "마감"
        labelView.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        return labelView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .callout, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private lazy var clubInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .vfGray3
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubviews(coverImageView, invalidLabel, categoryView, titleLabel, clubInfoLabel)
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: self.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 87)
        ])
        
        NSLayoutConstraint.activate([
            invalidLabel.topAnchor.constraint(equalTo: self.topAnchor),
            invalidLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            invalidLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            invalidLabel.heightAnchor.constraint(equalToConstant: 87)
        ])
        
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 8),
            categoryView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: clubInfoLabel.topAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            clubInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            clubInfoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configure(with item: Club) {
        coverImageView.setImage(with: item.coverImageURL)

        categoryView.configure(text: item.clubCategory, backgroundColor: .vfGray4 )
        titleLabel.text = item.clubTitle
        let participantsCount = item.participants?.count ?? 1
        clubInfoLabel.text = "\(item.placeToMeet)ㆍ\(participantsCount)/\(item.maxNumberOfPeople) 모집"
        
        let isShown = !(Date() > item.dateToMeet || (participantsCount == item.maxNumberOfPeople))
        invalidLabel.isHidden = isShown
        
    }
}
