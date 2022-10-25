//
//  LocationResultType.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/25.
//

import Foundation

private enum ResultType {
    case Address(addressName: String, longitudeX: String, latitudeY: String)
    case Place(placeName: String, addressName: String, longitudeX: String, latitudeY: String)
}
