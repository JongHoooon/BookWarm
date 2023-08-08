//
//  CollectionViewConfigureProtocol.swift
//  BookWarm
//
//  Created by JongHoon on 2023/08/03.
//

import UIKit

@objc
protocol CollectionViewConfigureProtocol: AnyObject {
    @objc optional func registerCell()
    @objc optional func configureCollectionView()
    func configureCollectionViewLayout()
}
