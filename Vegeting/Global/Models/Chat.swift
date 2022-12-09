//
//  Chat.swift
//  Vegeting
//
//  Created by yudonlee on 2022/10/23.
//

import Foundation

import FirebaseFirestoreSwift

struct Chat: Identifiable, Codable {
    @DocumentID var id: String?
    let chatRoomID: String?
    let clubID: String?
    let chatRoomName: String
    let participants: [Participant]?
    var messages: [Message]?
    var coverImageURL: URL?
}

struct Message: Identifiable, Codable {
    var id = UUID.init().uuidString
    let senderID, senderName: String
    let senderProfileImageURL: URL?
    let contentType: String
    let createdAt: Date
    let content: String?
}

