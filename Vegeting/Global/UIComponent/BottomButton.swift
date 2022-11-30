//
//  BottomButton.swift
//  Vegeting
//
//  Created by kelly on 2022/10/27.
//

import UIKit

class BottomButton: UIButton {

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
        titleLabel?.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .bold))
        setBackgroundColor(.vfYellow1, for: .normal)
        setBackgroundColor(.vfYellow2, for: .disabled)
        setTitleColor(.vfBlack, for: .normal)
        setTitleColor(.vfGray3, for: .disabled)
    }

    private func setupLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            self.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
