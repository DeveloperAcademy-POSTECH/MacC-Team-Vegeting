//
//  StringLiteral.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/20.
//

import Foundation

enum StringLiteral {
    
    static let exampleString = "안녕하세요"
    static let kakaoAPIKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    static let kakaoRestAPIAddress = "https://dapi.kakao.com/v2/local/search/address.json"
    static let kakaoRestAPIKeyword = "https://dapi.kakao.com/v2/local/search/keyword.json"
    
    // MARK: - SecondCreateGroupViewController
    
    static let secondCreateGroupViewControllerPhoto = "사진을 선택해주세요"
    static let secondCreateGroupViewControllerTitle = "모임의 제목을 입력해주세요"
    static let secondCreateGroupViewControllerContent = "모임의 상세설명을 입력해주세요"
    static let secondCreateGroupViewControllerRegisterButton = "등록하기"
    
    // MARK: - ReportTableViewCell
    
    static let reportTableViewCellTextViewPlaceholder = "내용을 입력해 주세요."
    static let reportTableViewCellTextViewOtherOption = "기타 (직접 입력)"
    
    // MARK: - notionLink
    
    static let privayPolicyNotionLink = "https://gabby-twilight-6a0.notion.site/47ed297f523c47229bb0e21822005d11"
    static let termsOfUseNotionLink = "https://gabby-twilight-6a0.notion.site/55b4430a5d7b4f6d819a891749d0e92e"
    static let suggestGoogleLink = "https://forms.gle/SATk9C6nUUWk5fMo9"
}
