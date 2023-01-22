//
//  MainCoordinator.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 05.01.2023.
//

import UIKit

class MainCoordinator {
    
    let tabBarController = UITabBarController()
    
    var currentNavigationController: UINavigationController {
        tabBarController.viewControllers?[tabBarController.selectedIndex] as! UINavigationController
    }
    
    func start(in window: UIWindow) {
        let homeViewModel = HomeViewModel(unsplashNetworkService: NetworkService())
        let homeVC = HomeViewController(viewModel: homeViewModel)
        homeViewModel.coordinator = HomeCoordinator(mainCoordinator: self)
        
        let favoriteViewModel = FavoriteViewModel()
        let favoriteVC = FavoriteViewController(viewModel: favoriteViewModel)
        favoriteViewModel.coordinator = FavoriteCoordinator(mainCoordinator: self)
        
        let controllers = [
            homeVC,
            favoriteVC
        ]
            .map { UINavigationController(rootViewController: $0) }
        
        tabBarController.setViewControllers(controllers, animated: false)
        window.rootViewController = tabBarController
    }
}
