//
//  NumberOfPeopleCollectionViewCell.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/23.
//

import UIKit

class NumberOfPeopleCollectionViewCell: UICollectionViewCell {
    
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
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - func
    
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
        backgroundContentView.layer.borderColor = UIColor.black.cgColor
        backgroundContentView.layer.borderWidth = 1
    }
    
    func applySelectedState() {
        backgroundContentView.backgroundColor = isSelected ? .black : .white
        itemLabel.textColor = isSelected ? .white : .black
        itemLabel.font = isSelected ? .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold)) : .preferredFont(forTextStyle:.subheadline)
    }
    
    func setItemLabel(with itemText: String) {
        itemLabel.text = itemText
    }
}
