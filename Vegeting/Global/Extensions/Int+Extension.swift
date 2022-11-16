//
//  Int+Extension.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/16.
//

import Foundation

extension Int {
    func toAgeGroup() -> String{
        let thisYear = Calendar.current.component(.year, from: Date())
        let age = thisYear - self + 1
        let ageGroup = (age / 10) * 10
        return String(ageGroup)
    }
}
