//
//  LookAroundCollectionViewCell.swift
//  BookWarm
//
//  Created by JongHoon on 2023/08/02.
//

import UIKit

class LookAroundCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var posterImageVIew: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImageVIew.configureCornerRadius(4.0)
    }
    
    func configureCell(item movie: Movie) {
        posterImageVIew.image = UIImage(named: "\(movie.title)")
    }

}
