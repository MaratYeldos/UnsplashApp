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
    
    private var modelId: String
    private var model: Photo!
    private let favoriteService = FavoriteUserDefault.shared
    
    private lazy var detailView = DetailView(frame: self.view.frame)
    
    //MARK: - Lifecycle
    
    init(with modelId: String) {
        self.modelId = modelId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(detailView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPhotoById()
        print("viewWillAppear")
    }
    
    private func getPhotoById() {
        NetworkService.shared.makePhotoByIdRequest(with: modelId) { res in
            switch res {
            case .success(let model):
                DispatchQueue.main.async { [weak self] in
                    self?.model = model
                    print("Init model")
                    self?.detailView.configureScreen(with: model)
                    self?.setupRightBarButton()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    @objc
    private func didTapAddToFavorite() {

        let isLiked = favoriteService.isLiked(with: modelId)

        let actionSheet = UIAlertController(title: "Photo by \(model.user?.username ?? "")",
                                            message: "Actions",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))

        actionSheet.addAction(UIAlertAction(title: isLiked ? "Remove from favorite" : "Add to favorite",
                                            style: isLiked ? .destructive : .default,
                                            handler: { [weak self] _ in
            guard let self = self else { return }
            if !isLiked {
                self.favoriteService.markAsLiked(with: self.model)
                DispatchQueue.main.async {
                    self.setupRightBarButton()
                }
            } else {
                self.favoriteService.unlike(with: self.model)
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
        let isLiked = favoriteService.isLiked(with: modelId)
        button.setImage(UIImage(systemName: isLiked ? "star.fill" : "star"), for: .normal)
        button.addTarget(self, action: #selector(didTapAddToFavorite), for: .touchUpInside)

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: button)
        ]
    }
}
