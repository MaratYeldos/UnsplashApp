//
//  NetworkService.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 04.01.2023.
//

import UIKit

enum NetworkErrors: Error {
    case wrongURL
    case dataIsEmpty
    case decodeIsFail
}

final class NetworkService {
    
    func baseRequest<T: Codable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let _ = request.url else {
            completion(.failure(NetworkErrors.wrongURL))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkErrors.dataIsEmpty))
                return
            }
            
            do {
                let decodedModel = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedModel))
            } catch {
                completion(.failure(NetworkErrors.decodeIsFail))
            }
        }.resume()
    }
}

extension NetworkService: NetworkServiceProtocol {
    
    func fetchPhotos(with params: PhotoURLParameters, and completion: @escaping (Result<[Photo], Error>) -> Void) {
        let request = URLFactory.getPhotos(params: params)
        self.baseRequest(request: request, completion: completion)
    }
    
    func fetchPhoto(with id: String, and completion: @escaping (Result<Photo, Error>) -> Void) {
        let request = URLFactory.getPhoto(by: id)
        self.baseRequest(request: request, completion: completion)
    }
    
    func fetchSearchPhotos(with params: PhotoURLParameters, and completion: @escaping (Result<SearchResult, Error>) -> Void) {
        let request = URLFactory.getPhotos(params: params)
        self.baseRequest(request: request, completion: completion)
    }
}
