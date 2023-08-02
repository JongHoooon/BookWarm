//
//  DetailViewController.swift
//  BookWarm
//
//  Created by JongHoon on 2023/07/31.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var movie: Movie?
    
    // MARK: - UI
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var bottomBackgroundView: UIView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureMovie()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.label
        ]
    }
    
    func configureDismissButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: BWImageNames.System.xmark),
            style: .plain,
            target: self,
            action: #selector(dismissView)
        )
    }
    
    @objc
    func dismissView() {
        dismiss(animated: true)
    }
    
}

// MARK: - Private Method

private extension DetailViewController {
    
    func configureUI() {
        postImageView.configureCornerRadius(4.0)
        
        bottomBackgroundView.layer.cornerRadius = 16.0
        bottomBackgroundView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        bottomBackgroundView.clipsToBounds = true
        bottomBackgroundView.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    func configureMovie() {
        guard let movie = movie else { return }
        
        postImageView.image = UIImage(named: movie.title)
        titleLabel.text = movie.title
        infoLabel.text = movie.infoText
        rateLabel.text = "평균 ★ \(movie.rate)"
        overViewLabel.text = movie.overview
        title = movie.title
        view.backgroundColor = movie.backgroundColor.color
    }
}
