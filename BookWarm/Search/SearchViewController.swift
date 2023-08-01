//
//  SearchViewController.swift
//  BookWarm
//
//  Created by JongHoon on 2023/07/31.
//

import UIKit

final class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "검색 화면"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: BWImageNames.xmark),
            style: .plain,
            target: self,
            action: #selector(dissmissBarButtonTapped)
        )
    }
    
    @objc
    private func dissmissBarButtonTapped() {
        dismiss(animated: true)
    }
}
