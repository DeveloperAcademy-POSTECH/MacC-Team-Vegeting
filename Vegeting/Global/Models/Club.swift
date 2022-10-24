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
    let clubID, clubTitle, clubCategory, hostID: String
    let participants: [Participant]?
    let createdAt: Date
    let maxNumberOfPeople: Int
    var coverImageURL: String?
    
}
