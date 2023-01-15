//
//  NetworkServiceProtocol.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 12.01.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchPhotos(with params: PhotoURLParameters, and completion: @escaping (Result<[Photo], Error>) -> Void)
    func fetchPhoto(with id: String, and completion: @escaping (Result<Photo, Error>) -> Void)
    func fetchSearchPhotos(with params: PhotoURLParameters, and completion: @escaping (Result<SearchResult, Error>) -> Void)
}
