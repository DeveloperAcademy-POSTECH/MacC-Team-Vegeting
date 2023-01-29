//
//  Place.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/25.
//

import Foundation

struct Address: Codable {
    let addressName: String
    let longitudeX: String
    let latitudeY: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case longitudeX = "x"
        case latitudeY = "y"
    }
}


struct AddressResponseModel: Codable {
    let documents: [Address]?

    enum Codingkeys: String, CodingKey {
        case addressList = "documents"
    }
}
