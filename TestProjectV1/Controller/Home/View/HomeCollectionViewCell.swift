//
//  HomeCollectionViewCell.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 05.01.2023.
//

import UIKit
import SDWebImage

final class HomeCollectionViewCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var setPhoto: Photo! {
        didSet {
            guard let urlRegularImage = setPhoto.urls?.regular, let imageURL = URL(string: urlRegularImage) else { return }
            photoImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            photoImageView.sd_setImage(with: imageURL)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoImageView)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
