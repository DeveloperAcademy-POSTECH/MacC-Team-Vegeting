//
//  RecentChat.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/09.
//

import Foundation

import FirebaseFirestoreSwift

struct RecentChat: Codable, Identifiable {
    @DocumentID var id: String?
    let chatRoomID: String?
    let chatRoomName: String?
    let lastSentMessage: String?
    let lastSentTime: Date?
    let coverImageURL: String?
    let messagesCount: Int?
}
