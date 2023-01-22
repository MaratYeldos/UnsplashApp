//
//  DetailViewModel.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 22.01.2023.
//

import Foundation

class DetailViewModel {
    
    private let id: String
    private let favoriteService: FavoriteUserDefault
    private let unsplashNetworkService: NetworkServiceProtocol
    
    var model: Photo?
    
    var isLiked: Bool {
        return favoriteService.isLiked(with: id)
    }
    
    init(id: String, unsplashNetworkService: NetworkServiceProtocol, favoriteService: FavoriteUserDefault) {
        self.id = id
        self.unsplashNetworkService = unsplashNetworkService
        self.favoriteService = favoriteService
    }
    
    func fetchPhoto(completion: @escaping (Result<Photo, Error>) -> Void) {
        unsplashNetworkService.fetchPhoto(with: id) { [weak self] result in
            switch result {
            case .success(let response):
                self?.model = response
                completion(.success(response))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    func addToFavorite() {
        guard let model = model else { return }
        favoriteService.markAsLiked(with: model)
    }
    
    func removeFromFavorite() {
        guard let model = model else { return }
        favoriteService.unlike(with: model)
    }
}
