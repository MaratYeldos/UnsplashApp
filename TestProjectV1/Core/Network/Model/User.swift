//
//  User.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 05.01.2023.
//

import Foundation

struct User: Codable {
    let username: String
    let name: String
    let profileImage: [UserInfoAvatarURL.RawValue: String]
    
    enum CodingKeys: String, CodingKey {
        case username
        case name
        case profileImage = "profile_image"
    }
    
    enum UserInfoAvatarURL: String {
        case small
        case medium
        case large
    }
}
