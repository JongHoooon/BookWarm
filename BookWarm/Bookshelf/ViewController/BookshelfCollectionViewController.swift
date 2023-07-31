//
//  BookshelfCollectionViewController.swift
//  BookWarm
//
//  Created by JongHoon on 2023/07/31.
//

import UIKit


final class BookshelfCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        configureCollectionViewLayout()
        
        title = "brick의 책장"
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
    
}

// MARK: - Collection View

extension BookshelfCollectionViewController {
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        return MovieInfo.movies.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookshelfCollectionViewCell.identifier,
            for: indexPath
        ) as! BookshelfCollectionViewCell
        
        let item = MovieInfo.movies[indexPath.item]
        cell.configureMovieCell(item: item)
        cell.configureBackground()
        
        return cell
    }
    
}
