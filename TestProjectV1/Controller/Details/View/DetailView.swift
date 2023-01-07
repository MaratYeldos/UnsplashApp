//
//  DetailView.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 07.01.2023.
//

import UIKit
import SDWebImage

final class DetailView: UIView {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [photoImageView, authorNameLabel, publicationDateLabel, locationLabel, downloadsNumberLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            photoImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            photoImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            photoImageView.heightAnchor.constraint(equalToConstant: 300),
            
            authorNameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 25),
            publicationDateLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 25),
            locationLabel.topAnchor.constraint(equalTo: publicationDateLabel.bottomAnchor, constant: 25),
            downloadsNumberLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 25)
        ])
        
        [authorNameLabel, publicationDateLabel, locationLabel, downloadsNumberLabel].forEach {
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
            $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15).isActive = true
            $0.widthAnchor.constraint(equalToConstant: bounds.size.height - 15).isActive = true
        }
    }
    
    func configureScreen(with model: Photo) {
        photoImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        photoImageView.sd_setImage(with: URL(string: model.urls?.full ?? ""), completed: nil)

        authorNameLabel.text = "Author: \(model.user?.username ?? "") - \(model.user?.name ?? "")"
        publicationDateLabel.text = "Published: \(model.createdAt?.prefix(10) ?? "")"
        downloadsNumberLabel.text = "Downloads: \(model.downloads ?? 0)"

        if let city = model.location?.city, let country = model.location?.country {
            locationLabel.text = "Location: " + city + ", " + country
        } else {
            locationLabel.text = "Location: unspecified"
        }
    }
}
