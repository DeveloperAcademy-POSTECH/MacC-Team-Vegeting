//
//  RecentChat.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/09.
//

import Foundation

struct RecentChat {
    @DocumentID var id: String?
    let chatRoomID: String?
    let chatRoomName: String?
    let lastSentMessage: String?
    let lastSentTime: Date?
}
