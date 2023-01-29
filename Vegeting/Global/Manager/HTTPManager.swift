//
//  HTTPManager.swift
//  Vegeting
//
//  Created by yudonlee on 2023/01/29.
//

import UIKit

final class HTTPManager {
    private init() { }
    static let shared = HTTPManager()

    func request(_ urlRequest: URLRequest, method: HTTPMethod, headers: [String: String], params: [String: String]) {
        
    }
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}
