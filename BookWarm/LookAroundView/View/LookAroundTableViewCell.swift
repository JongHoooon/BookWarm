//
//  LookAroundTableViewCell.swift
//  BookWarm
//
//  Created by JongHoon on 2023/08/02.
//

import UIKit

class LookAroundTableViewCell: UITableViewCell {

    @IBOutlet weak private var posterImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var rateLabel: UILabel!
    @IBOutlet weak private var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImageView.configureCornerRadius(4.0)
    }
    
    func configureCell(row movie: Movie) {
        posterImageView.image = UIImage(named: "\(movie.title)")
        titleLabel.text = movie.title
        rateLabel.text = "평균 ★ \(movie.rate)"
        infoLabel.text = movie.infoText
    }
    
}
