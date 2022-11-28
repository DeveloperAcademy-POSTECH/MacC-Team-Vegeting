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
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var invalidView: UILabel = {
        let labelView = UILabel()
        labelView.clipsToBounds = true
        labelView.layer.cornerRadius = 8
        labelView.textAlignment = .center
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
        addSubviews(coverImageView, invalidView, categoryView, titleLabel, clubInfoLabel)
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: self.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 87)
        ])
        
        NSLayoutConstraint.activate([
            invalidView.topAnchor.constraint(equalTo: self.topAnchor),
            invalidView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            invalidView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            invalidView.heightAnchor.constraint(equalToConstant: 87)
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
        if item.coverImageURL == nil {
            coverImageView.image = UIImage(named: "groupCoverImage1")
        } else {
            guard let url = item.coverImageURL else { return }
            coverImageView.setImage(with: url)
        }
        categoryView.configure(text: item.clubCategory, backgroundColor: .vfGray4 )
        titleLabel.text = item.clubTitle
        let participantsCount = item.participants?.count ?? 1
        clubInfoLabel.text = "\(item.placeToMeet)ㆍ\(participantsCount)/\(item.maxNumberOfPeople) 모집"
        if Date() > item.dateToMeet || (participantsCount == item.maxNumberOfPeople) {
            invalidView.textColor = UIColor(hex: "#FFD243", alpha: 1 )
            invalidView.backgroundColor = UIColor(hex: "#000000", alpha: 0.5 )
        } else {
            invalidView.textColor = UIColor(hex: "#FFD243", alpha: 0 )
            invalidView.backgroundColor = UIColor(hex: "#000000", alpha: 0 )
        }
    }
}
