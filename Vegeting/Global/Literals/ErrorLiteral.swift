//
//  ErrorLiteral.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/16.
//

import Foundation

enum ErrorLiteral: Error {
    case emptyChatID
}

enum FBError: Error {
    case didFailToLoadChat
}
