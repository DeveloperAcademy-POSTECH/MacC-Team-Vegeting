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
    
}
