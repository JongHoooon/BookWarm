//
//  SearchViewController.swift
//  BookWarm
//
//  Created by JongHoon on 2023/07/31.
//

import UIKit

import Alamofire
import SwiftyJSON

final class SearchViewController: UIViewController {

    // MARK: - Properties
    
    var searchedBooks: [Book] = []
    
    // MARK: - UI
        
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureCollectionView()
        configureCollectionViewLayout()
        registerCell()
        searchBar.delegate = self
    }
}

// MARK: - Collection View

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        return searchedBooks.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookshelfCollectionViewCell.identifier,
            for: indexPath
        ) as! BookshelfCollectionViewCell
        
        let item = searchedBooks[indexPath.item]
        cell.configureBookCell(item: item)
        
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
}

extension SearchViewController: CollectionViewConfigureProtocol {
    
    func registerCell() {
        let nib = UINib(
            nibName: BookshelfCollectionViewCell.identifier,
            bundle: nil
        )
        searchCollectionView.register(
            nib,
            forCellWithReuseIdentifier: BookshelfCollectionViewCell.identifier
        )
    }
    
    func configureCollectionView() {
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
    }
    
    func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        
        let width: CGFloat = (UIScreen.main.bounds.width - 20.0 * 3) / 2.0
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(
            top: 20.0,
            left: 20.0,
            bottom: 20.0,
            right: 20.0
        )
        layout.minimumInteritemSpacing = 20.0
        layout.minimumLineSpacing = 20.0
        
        searchCollectionView.collectionViewLayout = layout
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}

private extension SearchViewController {
    
    func callRequest() {
        
        let url = "https://dapi.kakao.com/v3/search/book?query="
        let headers: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakaoKey)"]
        
        AF.request(
            url,
            method: .get,
            headers: headers
        )
        .validate()
        .responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let books = json["documents"].arrayValue
                    .map {
                        return Book(
                            title: $0["title"].stringValue,
                            releaseDate: $0["datetime"].stringValue,
                            thumbnail: $0["thumbnail"].stringValue
                        )
                    }
                
                print(books)
                
                self?.searchedBooks = books
                self?.searchCollectionView.reloadData()
                 
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func configureNavigationBar() {
        navigationItem.title = "검색 화면"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: BWImageNames.System.xmark),
            style: .plain,
            target: self,
            action: #selector(dissmissBarButtonTapped)
        )
    }

    @objc
    func dissmissBarButtonTapped() {
        dismiss(animated: true)
    }
}
