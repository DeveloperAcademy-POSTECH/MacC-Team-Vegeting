//
//  UIColor+Extension.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/20.
//

import UIKit

extension UIColor {
    
    static let vfYellow1 = UIColor(hex: "#FFD243")
    static let vfYellow2 = UIColor(hex: "#FFF6DA")
    static let vfYellow3 = UIColor(hex: "FFFCE4")
    
    static let vfGray1 = UIColor(hex: "#616161")
    static let vfGray2 = UIColor(hex: "#6C6D70")
    static let vfGray3 = UIColor(hex: "#8E8E93")
    static let vfGray4 = UIColor(hex: "#F2F2F2")
    
    static let vfBlack = UIColor(hex: "#333333")
    static let vfGreend = UIColor(hex: "#24A869")
    static let vfRed = UIColor(hex: "#ED4E4E")
    
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

