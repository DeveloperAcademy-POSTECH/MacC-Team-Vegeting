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
    let dateToMeet: Date
    let createdAt: Date
    let placeToMeet: String
    let maxNumberOfPeople: Int
    var coverImageURL: String?
}

struct IncompleteClub {
    var clubCategory: String
    var placeToMeet: String
    var dateToMeet: Date
    var maxNumberOfPeople: Int
}
