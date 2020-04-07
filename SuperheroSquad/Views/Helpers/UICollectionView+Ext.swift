//
//  UICollectionView+Ext.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

extension UICollectionView {

    func registerClass(_ cellType: SHRowType) {
        register(cellType.cellClass, forCellWithReuseIdentifier: cellType.identifier)
    }

    func registerNib(_ cellType: SHRowType) {

        if let nibName = cellType.nibName {
            let bundle = Bundle(for: cellType.cellClass)
            register(UINib(nibName: nibName, bundle: bundle), forCellWithReuseIdentifier: cellType.identifier)
        } else {
            fatalError("Cell type with identifier: \(cellType.identifier) doesn't have a nib name defined")
        }
    }
    
    func dequeueReusableCell(_ cellType: SHRowType, for indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
    }

}
