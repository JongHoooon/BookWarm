//
//  UIViewController+Extension.swift
//  BookWarm
//
//  Created by JongHoon on 2023/07/31.
//

import UIKit

extension UIViewController {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
