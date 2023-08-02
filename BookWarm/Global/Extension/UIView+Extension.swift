//
//  UIView+Extension.swift
//  BookWarm
//
//  Created by JongHoon on 2023/08/02.
//

import UIKit

extension UIView {
    func configureCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
