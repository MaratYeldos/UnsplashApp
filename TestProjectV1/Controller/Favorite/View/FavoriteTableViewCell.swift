//
//  FavoriteTableViewCell.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 05.01.2023.
//

import UIKit
import SDWebImage

final class FavoriteTableViewCell: UITableViewCell {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(photoImageView)
        contentView.addSubview(authorLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    private func setupUI() {
        NSLayoutConstraint.activate([
            photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            photoImageView.heightAnchor.constraint(equalToConstant: contentView.bounds.size.height - 10),
            photoImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/10),
            
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            authorLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 12),
            authorLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 5/10)
        ])
    
    }
    
    func configure(with model: Photo) {
        let imageUrl = model.urls?.thumb 
        photoImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        photoImageView.sd_setImage(with: URL(string: imageUrl ?? ""))
        authorLabel.text = "Author: \(model.user?.username ?? "") - \(model.user?.name ?? "")"
    }
}
