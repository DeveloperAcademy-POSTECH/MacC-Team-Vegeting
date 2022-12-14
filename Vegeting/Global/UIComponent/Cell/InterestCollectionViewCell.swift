//
//  InterestCollectionViewCell.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/03.
//

import UIKit

class InterestCollectionViewCell: UICollectionViewCell {
    
    // MARK: - properties
    
    private lazy var backgroundContentView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = self.bounds.size.height / 2
        return view
    }()
    
    private let interestLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            applySelectedState()
        }
    }
    
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
        interestLabel.constraint(top: backgroundContentView.topAnchor,
                                 leading: backgroundContentView.leadingAnchor,
                                 bottom: backgroundContentView.bottomAnchor,
                                 trailing: backgroundContentView.trailingAnchor,
                                 padding: UIEdgeInsets(top: 9, left: 24, bottom: 8, right: 24))
    }
    
    private func configureUI() {
        layer.masksToBounds = true
    }
    
    func configure(with itemText: String) {
        interestLabel.text = itemText
    }
    
    func applySelectedState() {
        backgroundContentView.backgroundColor = isSelected ? .black : .systemGray6
        interestLabel.textColor = isSelected ? .white : .black
        interestLabel.font = isSelected ? .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold)) : .preferredFont(forTextStyle:.subheadline)
    }
}
