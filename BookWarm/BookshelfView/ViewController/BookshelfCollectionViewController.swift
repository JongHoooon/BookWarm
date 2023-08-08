//
//  BookshelfCollectionViewController.swift
//  BookWarm
//
//  Created by JongHoon on 2023/07/31.
//

import UIKit


final class BookshelfCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var movies = MovieInfo().movies
    
    private var movieSearched = MovieInfo().movies
    
    // MARK: - UI
    
    private let searchBar = UISearchBar()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        
        registerCell()
        configureCollectionViewLayout()
        configureNavigationItems()
    }
    
    
    @IBAction private func searchBarButtonTapped(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(
            name: StroyboardNames.main,
            bundle: nil
        )
        
        guard let query = searchBar.text, query.count > 0 else {
            let alert = UIAlertController(
                title: nil,
                message: "한 글자 이상 입력해 주세요!",
                preferredStyle: .alert
            )
            let action = UIAlertAction(title: "확인", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
            
            return
        }
        
        let vc = sb.instantiateViewController(withIdentifier: SearchViewController.identifier) as! SearchViewController
        
        vc.query = query
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
    }
    
}

extension BookshelfCollectionViewController: CollectionViewConfigureProtocol {
    func registerCell() {
        
        let nib = UINib(
            nibName: BookshelfCollectionViewCell.identifier,
            bundle: nil
        )
        collectionView.register(
            nib,
            forCellWithReuseIdentifier: BookshelfCollectionViewCell.identifier
        )
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
        
        collectionView.collectionViewLayout = layout
    }
}

// MARK: - Private Method

private extension BookshelfCollectionViewController {
    
    /*
    func registerCell() {
        
        let nib = UINib(
            nibName: BookshelfCollectionViewCell.identifier,
            bundle: nil
        )
        collectionView.register(
            nib,
            forCellWithReuseIdentifier: BookshelfCollectionViewCell.identifier
        )
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
        
        collectionView.collectionViewLayout = layout
    }
     */
    
    func configureNavigationItems() {
        title = "brick의 책장"
        navigationItem.backButtonTitle = ""
        
        navigationItem.titleView = searchBar
        searchBar.tintColor = .label
        searchBar.placeholder = "검색어를 입력해주세요."
    }
    
    @objc
    func likeButtonTapped(_ sender: UIButton) {
        movieSearched[sender.tag].isLiked.toggle()
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
        }
        
        let tappedMovie = movieSearched[sender.tag]
        if let tappedIndex = movies.firstIndex(where: { $0.title == tappedMovie.title }) {
            movies[tappedIndex].isLiked.toggle()
        }
    }
}

// MARK: - Collection View

extension BookshelfCollectionViewController {
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        return movieSearched.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookshelfCollectionViewCell.identifier,
            for: indexPath
        ) as! BookshelfCollectionViewCell
        
        let item = movieSearched[indexPath.item]
        cell.configureMovieCell(item: item)
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(
            self,
            action: #selector(likeButtonTapped),
            for: .touchUpInside
        )
        
        return cell
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let sb = UIStoryboard(name: StroyboardNames.detail, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DetailViewController.identifier) as! DetailViewController
        
        vc.movie = movieSearched[indexPath.item]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Search Bar

extension BookshelfCollectionViewController: UISearchBarDelegate {
    
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        guard let text = searchBar.text else { return }
        
        movieSearched = text.isEmpty ?
            movies :
            movies.filter { $0.title.contains(text) }
        
        collectionView.reloadData()
    }
    
}
