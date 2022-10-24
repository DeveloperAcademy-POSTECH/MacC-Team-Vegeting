//
//  User.swift
//  Vegeting
//
//  Created by yudonlee on 2022/10/23.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let userID: String
    let imageURL: String?
    let participatedChats: [ParticipatedChatRoom]?
    let participatedClubs: [ParticipatedClub]?
}

struct ParticipatedChatRoom: Codable {
    let chatID, chatName: String
    let imageURL: String?
}

struct ParticipatedClub: Codable {
    let clubID, clubName: String
    let profileImageURL: String?
}

