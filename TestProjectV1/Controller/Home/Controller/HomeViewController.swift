//
//  ViewController.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 04.01.2023.
//

import UIKit
import CollectionViewWaterfallLayout
import SDWebImage

final class HomeViewController: UIViewController {
    
    var coordinator: HomeCoordinator!
    private let unsplashNetworkService: NetworkServiceProtocol
    private var params: PhotoURLParameters
    private var page: Int = 1
    private var typingThrottler: TypingThrottler?
    private var cellSizes: [CGSize] = []
    
    var photoData: [Photo] = [] {
        didSet {
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk()
            cellSizes.removeAll()
            cellSizes = photoData.map { CGSize(width: $0.width, height: $0.height) }
        }
    }
    
    //MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = CollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.placeholder = "Search photos ..."
        sc.searchBar.searchBarStyle = .minimal
        sc.definesPresentationContext = true
        return sc
    }()
    
    //MARK: - Lifecycle
    
    init(unsplashNetworkService: NetworkServiceProtocol) {
        self.unsplashNetworkService = unsplashNetworkService
        self.params = PhotoURLParameters(page: String(self.page))
        super.init(nibName: nil, bundle: nil)
        
        tabBarItem = UITabBarItem(title: "Main",
                                  image: UIImage(systemName: "house"),
                                  selectedImage: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        collectionView.register(HomeCollectionViewCell.self)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        getRandomData()

        typingThrottler = TypingThrottler { [weak self] text in
            self?.getSearchResults(with: text)
        }
    }
}

//MARK: - Private Functions

extension HomeViewController {
    
    private func setupUI() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    //MARK: - FetchAPI
    
    private func getRandomData() {
        unsplashNetworkService.fetchPhotos(with: params) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.photoData = response
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getSearchResults(with searchTerm: String) {
        photoData.removeAll()
        params.query = searchTerm
        unsplashNetworkService.fetchSearchPhotos(with: params) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.photoData = response.results
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - Search

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        typingThrottler?.handleTyping(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getRandomData()
    }
}

//MARK: - DelegateDatasource methods

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        let photo = photoData[indexPath.item]
        cell.setPhoto = photo
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let current = photoData[indexPath.item]
        coordinator.showDetailScreen(with: current.id)
    }
}

extension HomeViewController: CollectionViewWaterfallLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSizes[indexPath.item]
    }
}

