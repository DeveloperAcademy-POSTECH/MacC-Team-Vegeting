//
//  User.swift
//  Vegeting
//
//  Created by yudonlee on 2022/10/23.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    let uid: String
    let imageURL: String?
    let participatedChats: [ParticipatedChat]?
    let participatedClubs: [ParticipatedClub]?
}

struct ParticipatedChat: Identifiable, Decodable {
    var id: String { chatID }
    let chatID, chatName: String
    let imageURL: String?
}

struct ParticipatedClub: Identifiable, Decodable {
    var id: String { clubID }
    let clubID, clubName: String
    let imageURL: String?
}

