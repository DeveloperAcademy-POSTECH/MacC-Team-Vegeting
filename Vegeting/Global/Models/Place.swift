//
//  Place.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/25.
//

import Foundation

struct Place: Codable {
    let placeName: String
    let addressName: String
    let longitudeX: String
    let latitudeY: String
    
    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case addressName = "road_address_name"
        case longitudeX = "x"
        case latitudeY = "y"
    }
}

struct PlaceResponseModel: Codable {
    let placeList: [Place]?
    enum CodingKeys: String, CodingKey {
        case placeList = "documents"
    }
}

