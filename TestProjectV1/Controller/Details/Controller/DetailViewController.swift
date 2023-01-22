//
//  DetailViewController.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 04.01.2023.
//

import UIKit
import SDWebImage

final class DetailViewController: UIViewController {
    
    //MARK: - Properties

    private let viewModel: DetailViewModel
    
    private lazy var detailView = DetailView(frame: self.view.frame)
    
    //MARK: - Lifecycle
    
    init(with id: String, unsplashNetworkService: NetworkServiceProtocol, favoriteService: FavoriteUserDefault) {
        viewModel = DetailViewModel(id: id, unsplashNetworkService: unsplashNetworkService, favoriteService: favoriteService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(detailView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchPhoto { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.detailView.configureScreen(with: response)
                    self?.setupRightBarButton()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    @objc
    private func didTapAddToFavorite() {

        let actionSheet = UIAlertController(title: "Photo by \(viewModel.model?.user?.username ?? "")",
                                            message: "Actions",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))

        actionSheet.addAction(UIAlertAction(title: viewModel.isLiked ? "Remove from favorite" : "Add to favorite",
                                            style: viewModel.isLiked ? .destructive : .default,
                                            handler: { [weak self] _ in
            guard let self = self else { return }
            if !self.viewModel.isLiked {
                self.viewModel.addToFavorite()
                DispatchQueue.main.async {
                    self.setupRightBarButton()
                }
            } else {
                self.viewModel.removeFromFavorite()
                DispatchQueue.main.async {
                    self.setupRightBarButton()
                }
            }

        }))

        present(actionSheet, animated: true)
    }
}

extension DetailViewController {
        
    private func setupRightBarButton() {
        let button = UIButton(type: .custom)
        let isLiked = viewModel.isLiked 
        button.setImage(UIImage(systemName: isLiked ? "star.fill" : "star"), for: .normal)
        button.addTarget(self, action: #selector(didTapAddToFavorite), for: .touchUpInside)

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: button)
        ]
    }
}
