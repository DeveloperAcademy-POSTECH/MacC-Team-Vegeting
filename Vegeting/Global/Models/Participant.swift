//
//  Participant.swift
//  Vegeting
//
//  Created by yudonlee on 2022/10/23.
//

import Foundation

struct Participant: Identifiable, Decodable {
    var id: String { uid }
    let uid: String
    let name: String
    var imageURL: String?
}
