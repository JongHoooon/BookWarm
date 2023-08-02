//
//  BWColors.swift
//  BookWarm
//
//  Created by JongHoon on 2023/08/02.
//

import UIKit

enum BWColor: CaseIterable {
    case label
    case brown
    case green
    case cyan
    case orange
    case darkGray
    case purple
    case link
    case blue
    case systemTeal
    case systemGreen
    
    var color: UIColor {
        switch self {
        case .label:            return .label
        case .brown:            return .brown
        case .green:            return .green
        case .cyan:             return .cyan
        case .orange:           return .orange
        case .darkGray:         return .darkGray
        case .purple:           return .purple
        case .link:             return .link
        case .blue:             return .blue
        case .systemTeal:       return .systemTeal
        case .systemGreen:      return .systemGreen
        }
    }
}
