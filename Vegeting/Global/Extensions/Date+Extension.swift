//
//  Date+Extension.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/23.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
