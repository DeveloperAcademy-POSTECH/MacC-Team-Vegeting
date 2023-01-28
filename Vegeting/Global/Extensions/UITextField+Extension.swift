//
//  UITextField+Extension.swift
//  Vegeting
//
//  Created by kelly on 2022/10/25.
//

import UIKit

extension UITextField {
    func addLeftPadding(width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addRightPadding(width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    func underlined(color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.size.height,
                              width: self.frame.width, height: 2)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
