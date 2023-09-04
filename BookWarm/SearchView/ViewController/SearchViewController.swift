//
//  SearchViewController.swift
//  BookWarm
//
//  Created by JongHoon on 2023/07/31.
//

import UIKit

import Alamofire
import SwiftyJSON

final class SearchViewController: UIViewController, Alertable {

    // MARK: - Properties
    
    private var searchedBooks: [Book] = [] {
        didSet {
            searchCollectionView.reloadData()
        }
    }
    private var page = 1
    private var isEnd = false
    private var query = ""
    
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
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let sb = UIStoryboard(name: StroyboardNames.detail, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DetailViewController.identifier) as! DetailViewController
        let item = searchedBooks[indexPath.item]
        vc.detailViewType = .book(book: item)
        navigationController?.pushViewController(
            vc,
            animated: true
        )
        
    }
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
        searchCollectionView.prefetchDataSource = self
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

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(
        _ collectionView: UICollectionView,
        prefetchItemsAt indexPaths: [IndexPath]
    ) {
        let rows = indexPaths.map { $0.row }
        
        if rows.contains(searchedBooks.count-1) &&
           isEnd == false {
            
            page += 1
            callRequest(query: query)
        }
    }
}

// MARK: - Search Bar

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text,
              query.count > 0 else {
            presnetSimpleAlert(message: "한 글자 이상 입력해 주세요!")
            return
        }
        
        page = 1
        self.query = query
        searchedBooks.removeAll()
        callRequest(query: query)
    }
    
}

// MARK: - Private Method

private extension SearchViewController {
    
    func callRequest(query: String) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            self.presnetSimpleAlert(message: "검색어를 확인해주세요!")
            return
        }
        let url = "https://dapi.kakao.com/v3/search/book?query=\(query)&size=15&page=\(page)"
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
                
                self?.isEnd = json["meta"]["is_end"].boolValue
                
                let books = json["documents"].arrayValue
                    .map {
                        return Book(
                            isbn: $0["isbn"].stringValue,
                            title: $0["title"].stringValue,
                            thumbnail: $0["thumbnail"].stringValue,
                            releaseDate: $0["datetime"].stringValue
                        )
                    }
                
                print(books)
                
                if books.isEmpty && self?.page == 1 {
                    self?.presnetSimpleAlert(message: "검색 결과가 없습니다.")
                } else {
                    self?.searchedBooks.append(contentsOf: books)
                }
                
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
        navigationItem.backButtonTitle = ""
    }

    @objc
    func dissmissBarButtonTapped() {
        dismiss(animated: true)
    }
}
