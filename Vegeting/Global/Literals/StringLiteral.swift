//
//  StringLiteral.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/20.
//

import Foundation

enum StringLiteral {
    
    static let exampleString = "안녕하세요"
    static let kakaoAPIKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY")
    static let kakaoRestAPIAddress = "https://dapi.kakao.com/v2/local/search/address.json"
    static let kakaoRestAPIKeyword = "https://dapi.kakao.com/v2/local/search/keyword.json"
    
}
