//
//  ImageLiteral.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/20.
//

import UIKit

enum ImageLiteral {

    // MARK: - SFSymbol
    
    static var backwardChevronSymbol: UIImage { .load(systemName: "chevron.backward") }
    static var exclamationMarkSymbol: UIImage { .load(systemName: "exclamationmark.circle") }
}

extension UIImage {
    static func load(name: String) -> UIImage {
        guard let image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = name
        return image
    }
    
    static func load(systemName: String) -> UIImage {
        guard let image = UIImage(systemName: systemName, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = systemName
        return image
    }
    
    func resize(to size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
