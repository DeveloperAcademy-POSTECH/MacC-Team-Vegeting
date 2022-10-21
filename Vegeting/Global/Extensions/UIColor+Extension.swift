//
//  UIColor+Extension.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/20.
//

import UIKit

extension UIColor {

    static var buttonBlack: UIColor {
        return UIColor(hex: "#464646")
    }
    
    static var mainMint: UIColor {
        return UIColor(hex: "#6FD1BE")
    }

    static var inactivateColor: UIColor {
        return UIColor(hex: "#DDDDDD")
    }

    static var practitionerRed: UIColor {
        return UIColor(hex: "#DC311E")
    }

    static var practitionerBlue: UIColor {
        return UIColor(hex: "#3876BD")
    }

    static var practitionerYellowGreen: UIColor {
        return UIColor(hex: "#BDCC00")
    }

    static var practitionerRedOrange: UIColor {
        return UIColor(hex: "#EC3915")
    }

    static var practitionerIndigo: UIColor {
        return UIColor(hex: "#243D8A")
    }

    static var practitionerGreen: UIColor {
        return UIColor(hex: "#4E9F00")
    }

    static var practitionerPurple: UIColor {
        return UIColor(hex: "#5C2C78")
    }

    static var practitionerBlueGreen: UIColor {
        return UIColor(hex: "#2C844D")
    }

    static var practitionerOrange: UIColor {
        return UIColor(hex: "#EF8D00")
    }

    static var practitionerMagenta: UIColor {
        return UIColor(hex: "#CE2D66")
    }

    static var practitionerTurquoise: UIColor {
        return UIColor(hex: "#308770")
    }

    static var practitionerYellow: UIColor {
        return UIColor(hex: "#F4D200")
    }
    
    static var humanColorRed: UIColor {
        return UIColor(hex: "#ee3d16")
    }
    
    static var humanColorRedOrange: UIColor {
        return UIColor(hex: "#ef5a12")
    }
    
    static var humanColorOrange: UIColor {
        return UIColor(hex: "#f2ab00")
    }
    
    static var humanColorYellow: UIColor {
        return UIColor(hex: "#f9ff00")
    }
    
    static var humanColorYellowGreen: UIColor {
        return UIColor(hex: "#9ccb1e")
    }
    
    static var humanColorGreen: UIColor {
        return UIColor(hex: "#267e00")
    }
    
    static var humanColorTurquise: UIColor {
        return UIColor(hex: "#6adccf")
    }
    
    static var humanColorBlueGreen: UIColor {
        return UIColor(hex: "#4daea9")
    }
    
    static var humanColorBlue: UIColor {
        return UIColor(hex: "#4200ff")
    }
    
    static var humanColorIndigo: UIColor {
        return UIColor(hex: "#4c0784")
    }
    
    static var humanColorMagenta: UIColor {
        return UIColor(hex: "#f539ff")
    }
    
    static var humanColorPurple: UIColor {
        return UIColor(hex: "#7b1882")
    }
    
    static var backgroundColor: UIColor {
        return UIColor(hex: "#F9F9FC")
    }
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

