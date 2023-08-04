//
//  LookAroundViewController.swift
//  BookWarm
//
//  Created by JongHoon on 2023/08/02.
//

import UIKit

final class LookAroundViewController: UIViewController {
    
    // MARK: - Properties
    
    private let movies = MovieInfo().movies
    
    // MARK: - UI
    
    @IBOutlet weak private var lookAroundTableView: UITableView!
    @IBOutlet weak private var lookAroundCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        configureTableView()
        configureCollectionView()
        configureCollectionViewLayout()
        configureNavigationBar()
    }
    
}

extension LookAroundViewController: CollectionViewConfigureProtocol,
                                    TableViewConfigureProtocol {
    func registerCell() {
        let tableViewNib = UINib(
            nibName: LookAroundTableViewCell.identifier,
            bundle: nil
        )
        lookAroundTableView.register(
            tableViewNib,
            forCellReuseIdentifier: LookAroundTableViewCell.identifier
        )
        
        let collectionViewNib = UINib(
            nibName: LookAroundCollectionViewCell.identifier,
            bundle: nil
        )
        lookAroundCollectionView.register(
            collectionViewNib,
            forCellWithReuseIdentifier: LookAroundCollectionViewCell.identifier
        )
    }
    
    func configureCollectionView() {
        lookAroundCollectionView.delegate = self
        lookAroundCollectionView.dataSource = self
    }
    
    func configureCollectionViewLayout() {
        lookAroundCollectionView.showsHorizontalScrollIndicator = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(
            width: 146.0 * (2/3),
            height: 146.0
        )
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 20.0,
            bottom: 0,
            right: 20.0
        )
        layout.minimumLineSpacing = 20.0
        lookAroundCollectionView.collectionViewLayout = layout
    }
    
    func configureTableView() {
        lookAroundTableView.delegate = self
        lookAroundTableView.dataSource = self
        
        lookAroundTableView.rowHeight = 124.0
    }
}

// MARK: - Private Method

private extension LookAroundViewController {
    
    /*
    func registerCell() {
        let tableViewNib = UINib(
            nibName: LookAroundTableViewCell.identifier,
            bundle: nil
        )
        lookAroundTableView.register(
            tableViewNib,
            forCellReuseIdentifier: LookAroundTableViewCell.identifier
        )

        let collectionViewNib = UINib(
            nibName: LookAroundCollectionViewCell.identifier,
            bundle: nil
        )
        lookAroundCollectionView.register(
            collectionViewNib,
            forCellWithReuseIdentifier: LookAroundCollectionViewCell.identifier
        )
    }
    
    func configureTableView() {
        lookAroundTableView.delegate = self
        lookAroundTableView.dataSource = self

        lookAroundTableView.rowHeight = 124.0
    }
    
    func configureCollectionViewLayout() {
        lookAroundCollectionView.delegate = self
        lookAroundCollectionView.dataSource = self

        lookAroundCollectionView.showsHorizontalScrollIndicator = false

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(
            width: 146.0 * (2/3),
            height: 146.0
        )
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 20.0,
            bottom: 0,
            right: 20.0
        )
        layout.minimumLineSpacing = 20.0
        lookAroundCollectionView.collectionViewLayout = layout
    }
     */
    
    func configureNavigationBar() {
        navigationItem.title = "둘러보기"
    }
    
    func prentDetailView(index: Int) {
        let sb = UIStoryboard(name: StroyboardNames.detail, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DetailViewController.identifier) as! DetailViewController
        let nav = UINavigationController(rootViewController: vc)
        
        vc.movie = movies[index]
        vc.configureDismissButton()
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
    }
}

// MARK: - Collecion View

extension LookAroundViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        return movies.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LookAroundCollectionViewCell.identifier,
            for: indexPath
        ) as! LookAroundCollectionViewCell
        
        let item = movies[indexPath.item]
        cell.configureCell(item: item)
        
        return cell
    }
}

extension LookAroundViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        prentDetailView(index: indexPath.item)
    }
    
}

// MARK: - Table View

extension LookAroundViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return movies.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LookAroundTableViewCell.identifier) as! LookAroundTableViewCell
        
        let row = movies[indexPath.row]
        cell.configureCell(row: row)
        
        return cell
    }
}

extension LookAroundViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
        prentDetailView(index: indexPath.row)
    }
}
