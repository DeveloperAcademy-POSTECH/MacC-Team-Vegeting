//
//  UIStackView+Extention.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/20.
//

import UIKit

extension UIStackView {

    func addArrangedSubviews (_ views: UIView...) {
        views.forEach { [weak self] view in
            self?.addArrangedSubview(view)
        }
    }

    func setHorizontalStack() {
        axis = .horizontal
        alignment = .center
        distribution = .equalSpacing
    }
    
    func setVerticalStack() {
        axis = .horizontal
        alignment = .center
        distribution = .equalSpacing
    }
}

