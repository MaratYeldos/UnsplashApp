//
//  HomeViewModel.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 07.01.2023.
//

import UIKit

final class HomeViewModel {
    
    var coordinator: HomeCoordinator!
    
    private let unsplashNetworkService: NetworkServiceProtocol
    private var params: PhotoURLParameters
    private var page: Int = 1
    var cellSizes: [CGSize] = []
    var onDataChanged: (() -> Void)?
    
    var photoData: [Photo] = [] {
        didSet {
            cellSizes.removeAll()
            cellSizes = photoData.map { CGSize(width: $0.width, height: $0.height) }
        }
    }
    
    init(unsplashNetworkService: NetworkServiceProtocol) {
        self.unsplashNetworkService = unsplashNetworkService
        self.params = PhotoURLParameters(page: String(self.page))
    }
    
    
    func getRandomData() {
        unsplashNetworkService.fetchPhotos(with: params) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    self.photoData = response
                    self.onDataChanged?()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func getSearchResults(with searchTerm: String) {
        photoData.removeAll()
        params.query = searchTerm
        unsplashNetworkService.fetchSearchPhotos(with: params) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.photoData = response.results
                    self.onDataChanged?()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func coordinateToDetail(with id: String) {
        coordinator.showDetailScreen(with: id)
    }
}
