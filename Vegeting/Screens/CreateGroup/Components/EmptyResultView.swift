//
//  EmptyResultView.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/26.
//

import UIKit

class EmptyResultView: UIView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: ImageLiteral.exclamationMarkSymbol)
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.large)
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "검색 결과를 찾을 수 없습니다.\n검색어가 정확한지 확인해 보세요."
        label.addLabelSpacing(lineSpacing: 5)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white
    }
    
    private func setupLayout() {
        addSubview(stackView)
        stackView.constraint(centerX: centerXAnchor, centerY: centerYAnchor)
        stackView.addArrangedSubviews(imageView, label)
    }
}

