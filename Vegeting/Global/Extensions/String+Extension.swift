//
//  String+Extension.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/23.
//

import Foundation

extension String {
    func toDate(format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else { return Date() }
        return date
    }
    
}
