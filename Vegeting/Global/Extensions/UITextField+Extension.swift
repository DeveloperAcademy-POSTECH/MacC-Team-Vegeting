//
//  UITextField+Extension.swift
//  Vegeting
//
//  Created by kelly on 2022/10/25.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func underlined(color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.size.height-1,
                              width: self.frame.width, height: 2)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
