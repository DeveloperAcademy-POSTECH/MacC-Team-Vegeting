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
        view.backgroundColor = .systemGray6
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
    
    // MARK: - func
    
    private func setupLayout() {
        addSubview(backgroundContentView)
        backgroundContentView.constraint(to: self)
        backgroundContentView.addSubview(itemLabel)
        itemLabel.constraint(centerX: self.centerXAnchor,
                             centerY: self.centerYAnchor)
    }
    
    private func configureUI() {
        backgroundContentView.layer.cornerRadius = 17
    }
    
    func applySelectedState() {
        print("??",isSelected)
        backgroundContentView.backgroundColor = isSelected ? .black : .systemGray6
        itemLabel.textColor = isSelected ? .white : .black
        itemLabel.font = isSelected ? .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold)) : .preferredFont(forTextStyle:.subheadline)
    }
    
    func configure(with itemText: String) {
        itemLabel.text = itemText
    }
}
