//
//  UserProfile.swift
//  Vegeting
//
//  Created by 김원희 on 2022/11/21.
//

import Foundation

class UserImageNickname { //1번 뷰컨
    var userImageURL: String?
    var userNickname: String
    
    init(userImageURL: String? = nil, userNickname: String) {
        self.userImageURL = userImageURL
        self.userNickname = userNickname
    }
}

class UserLocation { //2번 뷰컨
    var userImageNickname: UserImageNickname
    var userLocation: String
    
    init(userImageNickname: UserImageNickname, userLocation: String) {
        self.userImageNickname = userImageNickname
        self.userLocation = userLocation
    }
}

class UserGenderBirthYear { //3번 뷰컨
    var userLocation: UserLocation
    var userGender: String
    var userBirthYear: String
    
    init(userLocation: UserLocation, userGender: String, userBirthYear: String) {
        self.userLocation = userLocation
        self.userGender = userGender
        self.userBirthYear = userBirthYear
    }
}

class UserTypeIntroduction { //4번 뷰컨
    var userGenderBirthYear: UserGenderBirthYear
    var userVegetarianType: String
    var userIntroduction: String
    
    init(userGenderBirthYear: UserGenderBirthYear, userVegetarianType: String, userIntroduction: String) {
        self.userGenderBirthYear = userGenderBirthYear
        self.userVegetarianType = userVegetarianType
        self.userIntroduction = userIntroduction
    }
}
