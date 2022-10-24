//
//  UIView+Extension.swift
//  Vegeting
//
//  Created by yudonlee on 2022/10/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
}
