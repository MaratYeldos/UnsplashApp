//
//  FavoriteViewController.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 04.01.2023.
//

import UIKit

final class FavoriteViewController: UIViewController {
    
    var coordinator: FavoriteCoordinator!
    private var likedPhotos: [Photo] = []
    
    private lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.register(FavoriteTableViewCell.self)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorColor = .clear
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Favorite",
                                  image: UIImage(systemName: "star"),
                                  selectedImage: nil)
        likedPhotos = FavoriteUserDefault.shared.liked
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(likesChanged),
                                               name: FavoriteUserDefault.notificationKey,
                                               object: nil)
    }
    
    @objc
    private func likesChanged() {
        likedPhotos = FavoriteUserDefault.shared.liked
        tableview.reloadData()
    }
    
    private func setupUI() {
        view.addSubview(tableview)
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
}


extension FavoriteViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedPhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavoriteTableViewCell = tableView.dequeueCell(for: indexPath)
        let model = likedPhotos[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.coordinator?.showDetailScreen(with: likedPhotos[indexPath.item])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FavoriteUserDefault.shared.unlike(with: likedPhotos[indexPath.item])
        }
    }
}
