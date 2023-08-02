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

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureBackground()
    }
    
    private func configureBackground() {
        backgroundColor = .clear
        contentView.configureCornerRadius(16.0)
    }
    
    func configureMovieCell(item movie: Movie) {
        titleLabel.text = movie.title
        relaeseDateLabel.text = movie.trimedReleaseDate
        movieImageView.image = UIImage(named: "\(movie.title)")
        likeButton.setImage(movie.likeImage, for: .normal)
        contentView.backgroundColor = movie.backgroundColor.color
    }
}
