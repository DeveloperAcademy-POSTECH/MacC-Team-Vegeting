//
//  GroupCategoryCollectionViewCell.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/22.
//

import UIKit

final class GroupCategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - properties
    
    private let backgroundContentView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private let itemLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        return label
    }()
    
    private var isCellSelected = false
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        addSubview(backgroundContentView)
        backgroundContentView.constraint(to: self)
        backgroundContentView.addSubview(itemLabel)
        itemLabel.constraint(leading: backgroundContentView.leadingAnchor,
                                                   trailing: backgroundContentView.trailingAnchor,
                                                   centerY: self.centerYAnchor,
                                                   padding: UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14))
    }
    
    private func configureUI() {
        layer.masksToBounds = false
        let cellCornerRadius = (self.bounds.size.width * (self.bounds.size.height / self.bounds.size.width)) / 2
        backgroundContentView.layer.cornerRadius = cellCornerRadius
        
        makeShadow(color: .black,
                   opacity: 0.3,
                   offset: CGSize(width: 0, height: 2),
                   radius: 2)
    }
    
    func applySelectedState(_ isSelected: Bool) {
        backgroundContentView.backgroundColor = isSelected ? .black : .white
        itemLabel.textColor = isSelected ? .white : .black
        itemLabel.font = isSelected ? .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold)) : .preferredFont(forTextStyle:.subheadline)
        isCellSelected = isSelected
    }
    
    func setItemLabel(with itemText: String) {
        itemLabel.text = itemText
    }
}
