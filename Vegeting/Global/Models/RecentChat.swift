//
//  RecentChat.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/09.
//

import UIKit

import FirebaseFirestoreSwift

struct RecentChat: Codable, Identifiable {
    @DocumentID var id: String?
    let chatRoomID: String?
    let chatRoomName: String?
    let lastSentMessage: String?
    let lastSentTime: Date
    let numberOfParticipants: Int
    let coverImageURL: String?
}


struct RecentChatTest {
    let chatRoomID: String?
    let chatRoomName: String?
    let lastSentMessage: String?
    let lastSentTime: Date
    let numberOfParticipants: Int
    let coverImage: UIImage?
}
