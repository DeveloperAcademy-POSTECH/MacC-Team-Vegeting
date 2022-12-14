//
//  Int+Extension.swift
//  Vegeting
//
//  Created by μ΅λκΆ on 2022/11/16.
//

import Foundation

extension Int {
    func toAgeGroup() -> String {
        let thisYear = Calendar.current.component(.year, from: Date())
        let age = thisYear - self + 1
        let ageGroup = (age / 10) * 10
        
        return String(ageGroup) + "λ"
    }
}
