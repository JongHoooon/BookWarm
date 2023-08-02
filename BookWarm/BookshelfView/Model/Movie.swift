//
//  Movie.swift
//  Week3
//
//  Created by JongHoon on 2023/07/28.
//

import UIKit

struct Movie {
    let title: String
    let releaseDate: String
    let runtime: Int
    let overview: String
    let rate: Double
    var isLiked: Bool
    var backgroundColor: BWColor
}

extension Movie {
    var trimedReleaseDate: String {
        return releaseDate
            .split(separator: ".")
            .suffix(2)
            .joined(separator: ".")
    }
    
    var infoText: String {
        return [
            releaseDate, "\(runtime)분"
        ].joined(separator: " | ")
    }
    
    var likeImage: UIImage? {
        switch isLiked {
        case true:      return UIImage(systemName: BWImageNames.System.heartFill)
        case false:     return UIImage(systemName: BWImageNames.System.heart)
        }
    }
}
