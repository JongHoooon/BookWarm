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
    
    private var colors: [UIColor] = [
        .label, .brown, .green,
        .cyan, .red, .orange,
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
        var releaseDate = movie.releaseDate
        releaseDate = releaseDate
            .split(separator: ".")
            .suffix(2)
            .joined(separator: ".")
        
        titleLabel.text = movie.title
        relaeseDateLabel.text = releaseDate
        movieImageView.image = UIImage(named: "\(movie.title)")
    }
    
}
