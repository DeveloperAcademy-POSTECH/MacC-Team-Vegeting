//
//  NSObject+Extension.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/20.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
