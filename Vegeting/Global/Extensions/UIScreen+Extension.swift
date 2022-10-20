//
//  UIScreen+Extension.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/20.
//

import UIKit

extension UIScreen {
    var hasNotch: Bool {
        let deviceRatio = UIScreen.main.bounds.width / UIScreen.main.bounds.height
        return !(deviceRatio > 0.5)
    }
}
