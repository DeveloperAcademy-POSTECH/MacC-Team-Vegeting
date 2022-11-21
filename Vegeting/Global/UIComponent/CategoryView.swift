//
//  CategoryView.swift
//  Vegeting
//
//  Created by kelly on 2022/11/04.
//

import UIKit

class CategoryView: UIView {
    private let backgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        label.textColor = .vfBlack
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
        addSubviews(backgroundView)
        backgroundView.addSubviews(categoryLabel)
        
        NSLayoutConstraint.activate([
            backgroundView.widthAnchor.constraint(equalToConstant: 43),
            backgroundView.heightAnchor.constraint(equalToConstant: 23),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            categoryLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            categoryLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
    }
    
    private func configureUI() {
        frame = CGRect(x: 0, y: 0, width: 43, height: 22)
        backgroundView.layer.cornerRadius = 5
    }
    
    func configure(text: String, backgroundColor: UIColor) {
        backgroundView.backgroundColor = backgroundColor
        categoryLabel.text = text
    }
}
