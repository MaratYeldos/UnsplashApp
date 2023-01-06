//
//  NetworkService.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 04.01.2023.
//

import UIKit

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
}

protocol NetworkServiceProtocol {
    func configureParametersForUrl(with searchTerm: String?) -> [String : String]
    func configureUrl(with parameters: [String: String], path: String) -> URL?
    func makeRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void)
    func makeRandomPhotoRequest(completion: @escaping (Result<[Photo], Error>) -> Void)
    func makeSearchRequest(with searchTerm: String, completion: @escaping (Result<SearchResult, Error>) -> Void)
    func makePhotoByIdRequest(with id: String, completion: @escaping (Result<Photo, Error>) -> Void)
}

final class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    struct Constants {
        static let accessKey = "8gfkxsyDfTi09fsxh4Az90WPdskgDdJPcCdxRnmUL0k"
        static let urlScheme = "https"
        static let urlHost = "api.unsplash.com"
        static let searchURLPath = "/search/photos"
        static let randomPhotosPath = "/photos"
        
        // https://api.unsplash.com/photos/?client_id=8gfkxsyDfTi09fsxh4Az90WPdskgDdJPcCdxRnmUL0k
    }
    
    enum APIError: Error {
        case failedToGetData
    }
}


extension NetworkService: NetworkServiceProtocol {
    
    func configureParametersForUrl(with searchTerm: String? = nil) -> [String : String] {
        let pageParameter = 1
        let perPageParameter = 50
        var parameters: [String: String] = [:]
       
        if let searchTerm = searchTerm {
            parameters["query"] = searchTerm
        }
        
        parameters["page"] = "\(pageParameter)"
        parameters["per_page"] = "\(perPageParameter)"
        return parameters
    }
    
    func configureUrl(with parameters: [String : String], path: String) -> URL? {
        var urlComponent = URLComponents()
        urlComponent.scheme = Constants.urlScheme
        urlComponent.host = Constants.urlHost
        urlComponent.path = path
        
        if !parameters.isEmpty {
            urlComponent.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        
        return urlComponent.url
    }
    
    func makeRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        guard let url else { return }
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(Constants.accessKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = type.rawValue
        request.timeoutInterval = 30
        completion(request)
    }
    
    func makeRandomPhotoRequest(completion: @escaping (Result<[Photo], Error>) -> Void) {
        let prepareParameters = configureParametersForUrl()
        guard let url = configureUrl(with: prepareParameters, path: Constants.randomPhotosPath) else { return }
        
        load(with: url, type: .GET, completion: completion)
    }
    
    func makeSearchRequest(with searchTerm: String, completion: @escaping (Result<SearchResult, Error>) -> Void) {
        let prepareParameters = configureParametersForUrl(with: searchTerm)
        guard let url = configureUrl(with: prepareParameters, path: Constants.searchURLPath) else { return }
        
        load(with: url, type: .GET, completion: completion)
    }
    
    func makePhotoByIdRequest(with id: String, completion: @escaping (Result<Photo, Error>) -> Void) {
        let prepareParameters = configureParametersForUrl(with: id)
        guard let url = configureUrl(with: prepareParameters, path: Constants.randomPhotosPath + "/\(id)") else { return }
        
        load(with: url, type: .GET, completion: completion)
    }
    
    private func load<T: Codable>(with url: URL, type: HTTPMethod, completion: @escaping (Result<T, Error>) -> Void) {
        makeRequest(with: url, type: HTTPMethod.GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
}
