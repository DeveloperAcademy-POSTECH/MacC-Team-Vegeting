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
    let clubID: String?
    let chatID: String?
    let clubTitle, clubCategory: String
    let hostID: String?
    let participants: [Participant]?
    let createdAt: Date
    let maxNumberOfPeople: Int
    var coverImageURL: String?
    
<<<<<<< HEAD
    static let mockData = [Club(clubID: "", clubTitle: "동물해방 같이 읽어요.", clubCategory: "공부", hostID: "a", participants: Participant.mockData, createdAt: Date(), maxNumberOfPeople: 10, coverImageURL: "groupCoverImage1"),
                           Club(clubID: "", clubTitle: "매주 금요일마다 플로깅 하러 가실 분??", clubCategory: "맛집", hostID: "a", participants: Participant.mockData, createdAt: Date(), maxNumberOfPeople: 11, coverImageURL: "groupCoverImage2"),
                           Club(clubID: "", clubTitle: "매주 금요일마다 플로깅 하러 가실 분??", clubCategory: "친목", hostID: "a", participants: Participant.mockData, createdAt: Date(), maxNumberOfPeople: 12, coverImageURL: "groupCoverImage3"),
                           Club(clubID: "", clubTitle: "남미플랜트랩하고 거북이 먹으러 가요~!", clubCategory: "공부", hostID: "a", participants: Participant.mockData, createdAt: Date(), maxNumberOfPeople: 13, coverImageURL: "groupCoverImage2"),
                           Club(clubID: "", clubTitle: "같이 비건 식당 탐방하실 분?", clubCategory: "공부", hostID: "a", participants: Participant.mockData, createdAt: Date(), maxNumberOfPeople: 14, coverImageURL: "groupCoverImage1"),
                           Club(clubID: "", clubTitle: "동물권 관련 스터디", clubCategory: "맛집", hostID: "a", participants: Participant.mockData, createdAt: Date(), maxNumberOfPeople: 15, coverImageURL: "groupCoverImage3"),
                           Club(clubID: "", clubTitle: "기사 읽어보실 분~~", clubCategory: "맛집", hostID: "a", participants: Participant.mockData, createdAt: Date(), maxNumberOfPeople: 16, coverImageURL: "groupCoverImage1"),
                           Club(clubID: "", clubTitle: "비건 카페 가실분 계신가요?", clubCategory: "친목", hostID: "a", participants: Participant.mockData, createdAt: Date(), maxNumberOfPeople: 17, coverImageURL: "groupCoverImage2")
    ]
=======
>>>>>>> eb3e0ff7b826a9b5504095ac45e433da8851cd91
}
