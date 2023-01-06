//
//  PhotoURL.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 05.01.2023.
//

import Foundation

struct PhotoURL: Codable {
    let raw, full, regular, small: String?
    let thumb, smallS3: String?

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}
