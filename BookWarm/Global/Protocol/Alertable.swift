//
//  Alertable.swift
//  BookWarm
//
//  Created by JongHoon on 2023/08/09.
//

import UIKit

protocol Alertable {}

extension Alertable where Self: UIViewController {
    func presnetSimpleAlert(
        title: String? = nil,
        message: String
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(
            title: "확인",
            style: .default
        )
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true)
    }
}
