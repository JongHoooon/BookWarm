//
//  TableViewConfigureProtocol.swift
//  BookWarm
//
//  Created by JongHoon on 2023/08/03.
//

import UIKit

protocol TableViewConfigureProtocol: AnyObject {
    func registerCell()
    func configureCollectionViewLayout()
}
