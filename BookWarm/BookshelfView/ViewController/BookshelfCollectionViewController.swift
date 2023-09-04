//
//  BookshelfCollectionViewController.swift
//  BookWarm
//
//  Created by JongHoon on 2023/07/31.
//

import UIKit

import RealmSwift

final class BookshelfCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var movies = MovieInfo().movies
    private var movieSearched = MovieInfo().movies
    private var tasks: Results<BookTable>!
    
    // MARK: - UI
    
//    private let searchBar = UISearchBar()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        tasks = realm
            .objects(BookTable.self)
            .sorted(
                byKeyPath: "searchedDate",
                ascending: false
            )
        
        collectionView.keyboardDismissMode = .onDrag
        
        registerCell()
        configureCollectionViewLayout()
        configureNavigationItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    @IBAction private func searchBarButtonTapped(_ sender: UIBarButtonItem) {
        presentSearchView()
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
    }
    
    func presentSearchView() {
        let sb = UIStoryboard(
            name: StroyboardNames.search,
            bundle: nil
        )
        let vc = sb.instantiateViewController(withIdentifier: SearchViewController.identifier)
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
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
        
        return tasks.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookshelfCollectionViewCell.identifier,
            for: indexPath
        ) as! BookshelfCollectionViewCell
        
        let item = tasks[indexPath.item].toBook()
        cell.configureBookCell(item: item)
        
        return cell
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let sb = UIStoryboard(name: StroyboardNames.detail, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DetailViewController.identifier) as! DetailViewController
        
        let item = tasks[indexPath.item].toBook()
        vc.detailViewType = .book(book: item)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
