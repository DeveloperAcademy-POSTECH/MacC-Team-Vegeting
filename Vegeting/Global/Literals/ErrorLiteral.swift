//
//  ErrorLiteral.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/16.
//

import Foundation

enum FirebaseError: Error {
    case isClubIDInvalid
    case isChatIDInvalid
    case invalidID
    case didFailToLoadChat
    case didFailToLoadUser
}

enum StorageError: Error {
    case uploadFail
    case downloadFail
}

struct ErrorLiteral {
    enum KakaoAPI: Error {
        case failedToLoadPlace
        case failedToLoadAddress
        case invalidRestAPIKey
        case failedToDecodeData
        case failedToLoadData
    }
}
