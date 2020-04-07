//
//  UITableView+Ext.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

extension UITableView {

    func registerClass(_ cellType: SHRowType) {
        register(cellType.cellClass, forCellReuseIdentifier: cellType.identifier)
    }

    func registerNib(_ cellType: SHRowType) {

        if let nibName = cellType.nibName {
            let bundle = Bundle(for: cellType.cellClass)
            register(UINib(nibName: nibName, bundle: bundle), forCellReuseIdentifier: cellType.identifier)
        } else {
            fatalError("Cell type with identifier: \(cellType.identifier) doesn't have a nib name defined")
        }
    }

    func dequeueReusableCell(_ cellType: SHRowType, for indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath)
    }
}
