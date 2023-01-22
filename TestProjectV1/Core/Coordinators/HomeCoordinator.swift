//
//  HomeCoordinator.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 05.01.2023.
//

import UIKit

final class HomeCoordinator: MainCoordinator {
    
    weak var mainCoordinator: MainCoordinator?
    
    override var currentNavigationController: UINavigationController {
        mainCoordinator!.currentNavigationController
    }
    
    init(mainCoordinator: MainCoordinator) {
        self.mainCoordinator = mainCoordinator
    }

    func showDetailScreen(with model: String) {
        let vc = DetailViewController(with: model,
                                      unsplashNetworkService: NetworkService(),
                                      favoriteService: FavoriteUserDefault())
        vc.view.backgroundColor = .white
        self.currentNavigationController.pushViewController(vc, animated: true)
    }
}
