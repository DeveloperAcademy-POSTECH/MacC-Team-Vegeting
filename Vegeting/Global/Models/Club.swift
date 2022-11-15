//
//  Club.swift
//  Vegeting
//
//  Created by yudonlee on 2022/10/23.
//

import Foundation

import FirebaseFirestoreSwift

struct Club: Identifiable, Codable {
    @DocumentID var id: String?
    let clubID: String?
    let chatID: String?
    let clubTitle: String
    let clubCategory: String
    let clubContent: String
    let hostID: String?
    let participants: [Participant]?
    let createdAt: Date
    let maxNumberOfPeople: Int
    var coverImageURL: URL?
}

struct IncompleteClub {
    var clubCategory: String
    var clubLocation: String
    var createdAt: Date
    var maxNumberOfPeople: Int
}
