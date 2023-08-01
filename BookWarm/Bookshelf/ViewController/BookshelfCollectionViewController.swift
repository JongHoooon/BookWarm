//
//  BookshelfCollectionViewController.swift
//  BookWarm
//
//  Created by JongHoon on 2023/07/31.
//

import UIKit


final class BookshelfCollectionViewController: UICollectionViewController {
    
    private var movies = MovieInfo().movies {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        configureCollectionViewLayout()
        configureNavigationItems()
    }
    
    @IBAction private func searchBarButtonTapped(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(
            name: "Main",
            bundle: nil
        )
        let vc = sb.instantiateViewController(withIdentifier: SearchViewController.identifier)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
    }
    
}

// MARK: - Private Method

private extension BookshelfCollectionViewController {
    
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
    
    func configureNavigationItems() {
        title = "brick의 책장"
        navigationItem.backButtonTitle = ""
    }
    
    @objc
    func likeButtonTapped(_ sender: UIButton) {
        movies[sender.tag].isLiked.toggle()
    }
}

// MARK: - Collection View

extension BookshelfCollectionViewController {
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        return movies.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookshelfCollectionViewCell.identifier,
            for: indexPath
        ) as! BookshelfCollectionViewCell
        
        let item = movies[indexPath.item]
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
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DetailViewController.identifier) as! DetailViewController
        
        vc.detailTitle = movies[indexPath.item].title
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
