//
//  API.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 12.01.2023.
//

import Foundation

enum API {
    
    static let accessKey = "Client-ID 8gfkxsyDfTi09fsxh4Az90WPdskgDdJPcCdxRnmUL0k"
    static let authorization = "Authorization"
    static let baseUrl = "https://api.unsplash.com"
    
    enum Paths {
        static let searchURLPath = "/search/photos"
        static let randomPhotosPath = "/photos"
    }
}
