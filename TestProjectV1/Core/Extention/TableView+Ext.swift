//
//  TableView+Ext.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 04.01.2023.
//

import UIKit

extension UITableView {
    public func register(_ cellType: UITableViewCell.Type) {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    public func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError(
                "Не удалось сделать dequeue ячейки с типом \(T.self) " +
                    "и reuseIdentifier \(T.reuseIdentifier). " +
                    "Убедитесь, что вы зарегистировали ячейку"
            )
        }
        
        return cell
    }
}

public extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
