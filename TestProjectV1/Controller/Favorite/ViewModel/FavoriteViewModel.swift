//
//  FavoriteViewModel.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 22.01.2023.
//

import Foundation

protocol FavoriteViewModelDelegate: AnyObject {
    func onDataChanged()
}

class FavoriteViewModel {

    var coordinator: FavoriteCoordinator!
    weak var delegate: FavoriteViewModelDelegate?
    
    private(set) var likedPhotos: [Photo] = []
    
    init() {
        likedPhotos = FavoriteUserDefault.shared.liked
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(likesChanged),
                                               name: FavoriteUserDefault.notificationKey,
                                               object: nil)
    }
    
    @objc
    private func likesChanged() {
        likedPhotos = FavoriteUserDefault.shared.liked
        delegate?.onDataChanged()
    }
    
    func handleDelete(index: Int) {
        let photo = likedPhotos[index]
        FavoriteUserDefault.shared.unlike(with: photo)
        delegate?.onDataChanged()
    }
    
    func coordinateToDetail(with id: String) {
        coordinator.showDetailScreen(with: id)
    }
}
