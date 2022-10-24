//
//  PhotoPickerView.swift
//  Vegeting
//
//  Created by kelly on 2022/10/24.
//

import UIKit

class PhotoPickerView: UIView {
    var selectedImage = UIImageView()
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        backgroundColor = .systemGray4
        label.textColor = .white
        self.clipsToBounds = true
        selectedImage.contentMode = .scaleAspectFill
    }
    
    private func setupLayout() {
        addSubview(selectedImage)
        selectedImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectedImage.topAnchor.constraint(equalTo: self.topAnchor),
            selectedImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            selectedImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            selectedImage.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

}
