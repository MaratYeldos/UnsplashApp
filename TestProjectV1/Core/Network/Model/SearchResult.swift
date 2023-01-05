//
//  SearchResult.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 04.01.2023.
//

import UIKit

struct SearchResult: Codable {
    let total: Int
    let results: [Photo]
}
