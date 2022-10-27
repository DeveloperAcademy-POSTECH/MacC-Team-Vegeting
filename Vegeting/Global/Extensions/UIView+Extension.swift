//
//  UIView+Extension.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/22.
//

import UIKit

extension UIView {
    @discardableResult
    func makeShadow(color: UIColor,
                    opacity: Float,
                    offset: CGSize,
                    radius: CGFloat) -> Self {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        return self
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { [weak self] view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self?.addSubview(view)
        }
    }
}
