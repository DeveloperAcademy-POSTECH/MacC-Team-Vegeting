//
//  Participant.swift
//  Vegeting
//
//  Created by yudonlee on 2022/10/23.
//

import Foundation

struct Participant: Codable {
    let userID: String?
    let name: String
    let birth: Int?
    let location: String?
    let gender: String?
    let vegetarianType: String?
    let introduction: String?
    let interests: [String]?
    var profileImageURL: URL?
}
