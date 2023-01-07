//
//  FavoriteCoordinator.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 05.01.2023.
//

import UIKit

final class FavoriteCoordinator: MainCoordinator {
    
    weak var mainCoordinator: MainCoordinator?
    
    override var currentNavigationController: UINavigationController {
        mainCoordinator!.currentNavigationController
    }
    
    init(mainCoordinator: MainCoordinator) {
        self.mainCoordinator = mainCoordinator
    }
    
    func showDetailScreen(with modelId: String) {
        let vc = DetailViewController(with: modelId)
        vc.view.backgroundColor = .white
        self.currentNavigationController.pushViewController(vc, animated: true)
    }
}
