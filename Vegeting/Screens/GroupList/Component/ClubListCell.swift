//
//  GroupListCell.swift
//  Vegeting
//
//  Created by kelly on 2022/10/26.
//

import UIKit

class GroupListCell: UICollectionViewCell {
    private lazy var coverImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        [coverImage, titleLabel, placeLabelWithImage, countLabelWithImage].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
    }
    
    private func configureUI() {
        layer.masksToBounds = false
        let cellCornerRadius = (self.bounds.size.width * (self.bounds.size.height / self.bounds.size.width)) / 2
        layer.cornerRadius = cellCornerRadius
    }
}
