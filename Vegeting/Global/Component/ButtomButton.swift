//
//  ButtomButton.swift
//  Vegeting
//
//  Created by kelly on 2022/10/26.
//

import UIKit

class ButtomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        layer.masksToBounds = true
        layer.cornerRadius = 10
        titleLabel?.font = .preferredFont(forTextStyle: .body)
        setBackgroundColor(UIColor.green, for: .normal)
        setBackgroundColor(UIColor.gray, for: .disabled)
        setTitleColor(.white, for: .normal)
        setTitleColor(.white, for: .disabled)
    }
    
    private func setupLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            self.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
