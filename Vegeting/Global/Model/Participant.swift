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
    var profileImageURL: String?
    
    static let mockData = [Participant(userID: "a", name: "aa"),
                           Participant(userID: "b", name: "bb"),
                           Participant(userID: "c", name: "cc"),
                           Participant(userID: "d", name: "dd")]
}
