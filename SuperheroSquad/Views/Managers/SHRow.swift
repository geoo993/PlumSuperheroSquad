//
//  SHRow.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit


enum SHRowType: String {

    // MARK: - Cases
    
    case squad
    case heroes
    
    // MARK: - Properties

    var identifier: String {
        return rawValue.uppercased() + "CellID"
    }

    var nibName: String? {
        return String(describing: cellClass).components(separatedBy: ".").last
    }

    var cellClass: UIView.Type {
        switch self {
        case .squad:
            return SHSquadCollectionViewCell.self
        case .heroes:
            return SHHeroesTableViewCell.self
        }
    }
}

// MARK: -

struct SHRow<T> {
    
    // MARK: - Properties
    
    let type: SHRowType
    let data: T
    let width: CGFloat
    let accessoryType: UITableViewCell.AccessoryType
    
    // MARK: - Initialiser
    
    init(_ type: SHRowType, data: T, width: CGFloat = 0, accessoryType: UITableViewCell.AccessoryType = .none) {
        self.type = type
        self.data = data
        self.width = width
        self.accessoryType = accessoryType
    }
}
