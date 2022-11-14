//
//  UIColor+Extension.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/20.
//

import UIKit

extension UIColor {
    
    static let mainYellow = UIColor(hex: "#FFD243")
    static let mainDisabledYellow = UIColor(hex: "#FFF6DA")
    static let textFieldGray = UIColor(hex: "#F2F2F2")
    static let labelGray1 = UIColor(hex: "#8E8E93")
    static let labelGray2 = UIColor(hex: "#333333")
    
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}

