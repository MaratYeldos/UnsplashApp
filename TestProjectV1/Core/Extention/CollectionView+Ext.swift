//
//  CollectionView+Ext.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 04.01.2023.
//

import UIKit

extension UICollectionView {
    public func register(_ cellType: UICollectionViewCell.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    public func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError(
                "Не удалось сделать dequeue ячейки с типом \(T.self) " +
                    "и reuseIdentifier \(T.reuseIdentifier). " +
                    "Убедитесь, что вы зарегистировали ячейку"
            )
        }
        
        return cell
    }
}

public extension UICollectionViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
