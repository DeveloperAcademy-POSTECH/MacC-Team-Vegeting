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
    var profileImageURL: URL?
}
