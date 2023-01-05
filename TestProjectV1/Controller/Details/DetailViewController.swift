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
    
    private let photoImageView: UIImageView  = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let publicationDateLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let locationLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let downloadsNumberLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private var model: Photo
    private let favoriteService = FavoriteUserDefault.shared
    
    //MARK: - Lifecycle
    
    init(with model: Photo) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureScreen(with: model)
        setupRightBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureScreen(with: model)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    

    @objc
    private func didTapAddToFavorite() {
        
        let actionSheet = UIAlertController(title: "Photo by \(model.user?.username ?? "")",
                                            message: "Actions",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        
        let isLiked = favoriteService.isLiked(with: model.id)
        
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
    
    private func setupUI() {
        [photoImageView, authorNameLabel, publicationDateLabel, locationLabel, downloadsNumberLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            photoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            photoImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            photoImageView.heightAnchor.constraint(equalToConstant: 300),
            
            authorNameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 25),
            publicationDateLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 25),
            locationLabel.topAnchor.constraint(equalTo: publicationDateLabel.bottomAnchor, constant: 25),
            downloadsNumberLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 25)
        ])
        
        [authorNameLabel, publicationDateLabel, locationLabel, downloadsNumberLabel].forEach {
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
            $0.widthAnchor.constraint(equalToConstant: view.bounds.size.height - 15).isActive = true
        }
    }
    
    private func configureScreen(with model: Photo) {
        photoImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        photoImageView.sd_setImage(with: URL(string: model.urls["full"] ?? ""), completed: nil)
        authorNameLabel.text = "Author: " + (model.user?.username ?? "") + " - " + (model.user?.name ?? "")
        publicationDateLabel.text = "Published: " + String(model.createdAt?.prefix(10) ?? "")
        downloadsNumberLabel.text = "Downloads: " + String(model.downloads ?? 0)
        
        if let city = model.location?.city, let country = model.location?.country {
            locationLabel.text = "Location: " + city + ", " + country
        } else {
            locationLabel.text = "Location: unspecified"
        }
    }
    
    private func setupRightBarButton() {
        let button = UIButton(type: .custom)
        let isLiked = favoriteService.isLiked(with: model.id)
        button.setImage(UIImage(systemName: isLiked ? "star.fill" : "star"), for: .normal)
        button.addTarget(self, action: #selector(didTapAddToFavorite), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: button)
        ]
    }
}
