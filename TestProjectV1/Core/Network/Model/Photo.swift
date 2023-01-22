//
//  Photo.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 04.01.2023.
//

import Foundation

struct Photo: Codable {
    let id: String
    let width: Int
    let height: Int
    let urls: PhotoURL?
    let user: User?
    let downloads: Int?
    let location: PhotoLocation?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, urls, user, downloads, location
        case createdAt = "created_at"
    }
}

struct PhotoURLParameters {
    var page: String?
    var query: String
    
    init(page: String = "1", query: String = "") {
        self.page = page
        self.query = query
    }
}

