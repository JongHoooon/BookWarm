//
//  DetailViewController.swift
//  BookWarm
//
//  Created by JongHoon on 2023/07/31.
//

import UIKit

final class DetailViewController: UIViewController {
    
    var detailTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        title = detailTitle
    }
}
