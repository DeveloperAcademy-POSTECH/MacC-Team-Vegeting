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
    let chatRoomID,chatRoomName: String
    let participants: [Participant]?
    let messages: [Message]?
}

struct Message: Codable {
    let senderID, senderName: String
    let senderProfileImageURL: String?
    let contentType: String
    let imageURL: String?
    let content: String?
}

