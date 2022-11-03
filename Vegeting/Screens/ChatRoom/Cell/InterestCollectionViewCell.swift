//
//  InterestCollectionViewCell.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/03.
//

import UIKit

class InterestCollectionViewCell: UICollectionViewCell {
    
    // MARK: - properties
    
    private let backgroundContentView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let interestLabel: UILabel = {
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
        backgroundContentView.addSubview(interestLabel)
        interestLabel.constraint(leading: backgroundContentView.leadingAnchor,
                                                   trailing: backgroundContentView.trailingAnchor,
                                                   centerY: self.centerYAnchor,
                                                   padding: UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14))
    }
    
    private func configureUI() {
        layer.masksToBounds = false
        let cellCornerRadius = self.bounds.size.height / 2
        backgroundContentView.layer.cornerRadius = cellCornerRadius
    }

    func configure(with itemText: String) {
        interestLabel.text = itemText
    }
}
