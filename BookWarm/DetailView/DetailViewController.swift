//
//  DetailViewController.swift
//  BookWarm
//
//  Created by JongHoon on 2023/07/31.
//

import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var bottomBackgroundView: UIView!
    
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureMovie()
    }
    
    private func configureUI() {
        postImageView.layer.cornerRadius = 4.0
        
        bottomBackgroundView.layer.cornerRadius = 16.0
        bottomBackgroundView.clipsToBounds = true
        bottomBackgroundView.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    private func configureMovie() {
        guard let movie = movie else { return }
        
        postImageView.image = UIImage(named: movie.title)
        titleLabel.text = movie.title
        infoLabel.text = movie.infoText
        rateLabel.text = "평균 ★ \(movie.rate)"
        overViewLabel.text = movie.overview
        title = movie.title
        view.backgroundColor = movie.backgroundColor
    }
}
