//
//  UserProfile.swift
//  Vegeting
//
//  Created by 김원희 on 2022/11/21.
//

import Foundation

class FirstImageNickname {
    var userImageURL: URL?
    var userNickname: String
    
    init(userImageURL: URL? = nil, userNickname: String) {
        self.userImageURL = userImageURL
        self.userNickname = userNickname
    }
}

class SecondLocation {
    var userImageNickname: FirstImageNickname
    var userLocation: String
    
    init(userImageNickname: FirstImageNickname, userLocation: String) {
        self.userImageNickname = userImageNickname
        self.userLocation = userLocation
    }
}

class ThirdGenderBirthYear {
    var userLocation: SecondLocation
    var userGender: String
    var userBirthYear: Int
    
    init(userLocation: SecondLocation, userGender: String, userBirthYear: Int) {
        self.userLocation = userLocation
        self.userGender = userGender
        self.userBirthYear = userBirthYear
    }
}

class FourthTypeIntroduction {
    var userGenderBirthYear: ThirdGenderBirthYear
    var userVegetarianType: String
    var userIntroduction: String?
    
    init(userGenderBirthYear: ThirdGenderBirthYear, userVegetarianType: String, userIntroduction: String) {
        self.userGenderBirthYear = userGenderBirthYear
        self.userVegetarianType = userVegetarianType
        self.userIntroduction = userIntroduction
    }
}

class FifthInterests {
    var userTypeIntroduction: FourthTypeIntroduction
    var userInterest: [String]
    
    init(userTypeIntroduction: FourthTypeIntroduction, userInterest: [String]) {
        self.userTypeIntroduction = userTypeIntroduction
        self.userInterest = userInterest
    }
}
