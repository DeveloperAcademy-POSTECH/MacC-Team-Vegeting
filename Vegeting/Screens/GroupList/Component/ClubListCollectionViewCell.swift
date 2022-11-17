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
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .callout, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private lazy var clubInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .labelGray1
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
        addSubviews(coverImageView, categoryView, titleLabel, clubInfoLabel)
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: self.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 87)
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
        coverImageView.image = UIImage(named: item.coverImageURL ?? "groupCoverImage1")
        categoryView.configure(text: item.clubCategory, backgroundColor: .textFieldGray )
        titleLabel.text = item.clubTitle
        let participantsCount = item.participants?.count ?? 0
        clubInfoLabel.text = "서울시 동작구ㆍ\(participantsCount)/\(item.maxNumberOfPeople) 모집"
    }
}
