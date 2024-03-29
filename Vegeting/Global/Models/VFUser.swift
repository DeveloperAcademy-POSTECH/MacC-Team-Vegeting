//
//  User.swift
//  Vegeting
//
//  Created by yudonlee on 2022/10/23.
//

import Foundation
import FirebaseFirestoreSwift

struct VFUser: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    let userID: String
    let userName: String
    let imageURL: URL?
    let birth: Int?
    let location: String?
    let gender: String?
    let vegetarianType: String
    let introduction: String?
    let interests: [String]?
    let participatedChats: [ParticipatedChatRoom]?
    let participatedClubs: [ParticipatedClub]?
}

struct ParticipatedChatRoom: Hashable, Codable {
    var id = UUID().uuidString
    let chatID: String?
    let chatName: String
    let imageURL: URL?
    let lastReadIndex: Int?
}

struct ParticipatedClub: Hashable, Codable {
    var id = UUID().uuidString
    let clubID: String?
    let clubName: String
    let profileImageURL: URL?
}

