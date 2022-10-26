//
//  LabelWithImage.swift
//  Vegeting
//
//  Created by kelly on 2022/10/26.
//

import UIKit

class LabelWithImage: UIStackView {
    var imageName: String? {
        didSet { setCoverImage() }
    }
    
    var labelText: String? {
        didSet { setLabelText() }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pin")
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = ""
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
        distribution = .equalSpacing
    }
    
    private func setupLayout() {
        [imageView, label].forEach {
            addArrangedSubviews($0)
        }
    }
    
    private func setCoverImage() {
        imageView.image = UIImage(systemName: imageName ?? "pin") ?? UIImage()
    }
    
    private func setLabelText() {
        label.text = labelText
    }
}
