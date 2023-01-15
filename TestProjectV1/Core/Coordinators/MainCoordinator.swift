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
        let homeVC = HomeViewController(unsplashNetworkService: NetworkService())
        homeVC.coordinator = HomeCoordinator(mainCoordinator: self)
        
        let favoriteVC = FavoriteViewController()
        favoriteVC.coordinator = FavoriteCoordinator(mainCoordinator: self)
        
        let controllers = [
            homeVC,
            favoriteVC
        ]
            .map { UINavigationController(rootViewController: $0) }
        
        tabBarController.setViewControllers(controllers, animated: false)
        window.rootViewController = tabBarController
    }
}
