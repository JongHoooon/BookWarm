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
        titleLabel.textColor = .label
        relaeseDateLabel.textColor = .label
    }
    
    override func prepareForReuse() {
        movieImageView.backgroundColor = .clear
        movieImageView.image = nil
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
    
    func configureBookCell(item book: Book) {
        Task {
            await movieImageView.fetchImage(
                urlString: book.thumbnail,
                defaultImage: UIImage(systemName: BWImageNames.System.book),
                backgroundColorForError: .systemGray6
            )
        }
        let releaseDateText = book.releaseDate
            .prefix(10)
            .split(separator: "-")
            .suffix(2)
            .joined(separator: ".")
        
        relaeseDateLabel.text = releaseDateText
        titleLabel.text = book.title
        likeButton.isHidden = true
        contentView.backgroundColor = .systemGray3
    }
}
