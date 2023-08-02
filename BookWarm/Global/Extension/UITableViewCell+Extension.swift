//
//  UITableViewCell+Extension.swift
//  BookWarm
//
//  Created by JongHoon on 2023/08/02.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
