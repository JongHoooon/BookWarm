//
//  BookshelfCollectionViewCell.swift
//  BookWarm
//
//  Created by JongHoon on 2023/07/31.
//

import UIKit

final class BookshelfCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var relaeseDateLabel: UILabel!
    @IBOutlet weak private var movieImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    private var colors: [UIColor] = [
        .label, .brown, .green,
        .cyan, .orange, .darkGray,
        .purple, .link, .magenta,
        .blue, .systemTeal, .systemGreen
    ]
    
    func configureBackground() {
        backgroundColor = .clear
        contentView.backgroundColor = colors.randomElement()
        contentView.layer.cornerRadius = 16.0
        contentView.clipsToBounds = true
    }
    
    func configureMovieCell(item movie: Movie) {
        titleLabel.text = movie.title
        relaeseDateLabel.text = movie.trimedReleaseDate
        movieImageView.image = UIImage(named: "\(movie.title)")
        likeButton.setImage(movie.likeImage, for: .normal)
    }
    
}
