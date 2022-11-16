//
//  LabelWithImage.swift
//  Vegeting
//
//  Created by kelly on 2022/10/26.
//

import UIKit

class LabelWithImageStackView: UIStackView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .vfBlack
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .vfBlack
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        axis = .horizontal
        alignment = .center
        spacing = 2
    }
    
    private func setupLayout() {
        [imageView, label].forEach {
            addArrangedSubviews($0)
        }
    }
    
    func setCoverImage(image: UIImage?) {
        imageView.image = image
    }
    
    func setLabelText(text: String) {
        label.text = text
    }
}
