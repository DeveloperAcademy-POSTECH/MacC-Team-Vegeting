//
//  ChatRoomViewModel.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/13.
//

import Foundation

struct TemporaryMessage {
    let status: SenderType
    let profileUserName: String
    let messageContent: String
}

final class chatRoomViewModel {
    var temporaryMessages: [TemporaryMessage] = []
    
    init(count: Int) {
        for _ in 0..<count {
            let data = TemporaryMessage(status: randomTestSenderType(), profileUserName: randomUserNameText(), messageContent: randomContentText())
            temporaryMessages.append(data)
        }
    }
    
}

extension chatRoomViewModel {
    private func randomTestSenderType() -> SenderType {
        let randomSenderType = SenderType.allCases.randomElement()!
        return randomSenderType
    }
    
    private func randomContentText() -> String {
        let labelCase = ["감자님이 저번에 말씀하셨던 곳이 거기인가요?", "와 저도 거기 진짜 가보고 싶었는데 ....... 리조또랑 퐁듀가 진짜 맛있고, 피클도 꼭 추가해야 한대요~!!!!", "고구마 함박집 창문동에 담달에 드디어 오픈 한대요!", "타임은 LG 클로이 서브봇을 로보틱스 분야 최고의 발명품으로 꼽았다. 라이다 센서와 3D 카메라를 사용해 혼잡한 공간에서도 안정적으로 주행하고, 66파운드(30kg) 물품을 연속 11시간 운반할 수 있다고 설명했다. 가정용 식물재배기인 LG 틔운은 식물을 잘 키우는 요령이 없는 사람도 집안에서 쉽게 재배할 수 있는 점을 강조했다."]
        let idx = Int.random(in: 0...3)
        return labelCase[idx]
    }
    
    private func randomUserNameText() -> String {
        let labelCase = ["채식쪼아", "채식의 마술사", "채식없인 못살아"]
        let idx = Int.random(in: 0...2)
        return labelCase[idx]
    }
}
