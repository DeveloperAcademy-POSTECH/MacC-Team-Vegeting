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
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
    
    func toMessageTimeText() -> String {
        return toString(format: "a h:mm")
    }
    
}
