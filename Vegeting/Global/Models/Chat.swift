//
//  Chat.swift
//  Vegeting
//
//  Created by yudonlee on 2022/10/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Chat: Identifiable, Decodable {
    @DocumentID var id: String?
    let chatID,chatName: String
    let participants: [Participant]?
    let messages: [Message]?
}

struct Message: Identifiable, Decodable {
    var id: String?
    let senderID, senderName: String
    let senderImageURL: String?
    let contentType: String
    let imageURL: String?
    let content: String?
}

