//
//  MockData.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/04.
//
import UIKit

class MockData {
    static let club = [Club(clubID: "", chatID: "", clubTitle: "동물해방 같이 읽어요.", clubCategory: "공부", clubContent: "랄랄라", clubLocation: "포항효자동", hostID: "a",participants: participant, createdAt: Date(), maxNumberOfPeople: 10, coverImageURL: "groupCoverImage1"),
                       Club(clubID: "", chatID: "", clubTitle: "매주 금요일마다 플로깅 하러 가실 분??", clubCategory: "맛집", clubContent: "랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라", clubLocation: "포항효자동", hostID: "a", participants: participant, createdAt: Date(), maxNumberOfPeople: 11, coverImageURL: "groupCoverImage2"),
                       Club(clubID: "", chatID: "", clubTitle: "매주 금요일마다 플로깅 하러 가실 분??", clubCategory: "친목", clubContent: "랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라", clubLocation: "포항효자동", hostID: "a", participants: participant, createdAt: Date(), maxNumberOfPeople: 12, coverImageURL: "groupCoverImage3"),
                       Club(clubID: "", chatID: "", clubTitle: "남미플랜트랩하고 거북이 먹으러 가요~!", clubCategory: "공부", clubContent: "랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라랄랄라", clubLocation: "포항효자동", hostID: "a", participants: participant, createdAt: Date(), maxNumberOfPeople: 13, coverImageURL: "groupCoverImage2"),
                       Club(clubID: "", chatID: "", clubTitle: "같이 비건 식당 탐방하실 분?", clubCategory: "공부", clubContent: "랄랄라", clubLocation: "포항효자동", hostID: "a", participants: participant, createdAt: Date(), maxNumberOfPeople: 14, coverImageURL: "groupCoverImage1"),
                       Club(clubID: "", chatID: "", clubTitle: "동물권 관련 스터디", clubCategory: "맛집", clubContent: "같이 갈 사람 구합니다아아아 내용은 두줄만 적을게욤.", clubLocation: "포항효자동", hostID: "a", participants: participant, createdAt: Date(), maxNumberOfPeople: 15, coverImageURL: "groupCoverImage3"),
                       Club(clubID: "", chatID: "", clubTitle: "기사 읽어보실 분~~", clubCategory: "맛집", clubContent: "랄랄라", clubLocation: "포항효자동", hostID: "a", participants: participant, createdAt: Date(), maxNumberOfPeople: 16, coverImageURL: "groupCoverImage1"),
                       Club(clubID: "", chatID: "", clubTitle: "비건 카페 가실분 계신가요?", clubCategory: "친목", clubContent: "랄랄라", clubLocation: "포항효자동", hostID: "a", participants: participant, createdAt: Date(), maxNumberOfPeople: 17, coverImageURL: "groupCoverImage2")
    ]
    
    static let participant = [Participant(userID: "a", name: "aa"),
                              Participant(userID: "b", name: "bb"),
                              Participant(userID: "c", name: "cc"),
                              Participant(userID: "d", name: "dd"),
                              Participant(userID: "e", name: "ee"),
                              Participant(userID: "f", name: "ff"),
                              Participant(userID: "g", name: "gg"),
                              Participant(userID: "h", name: "hh")]
}
