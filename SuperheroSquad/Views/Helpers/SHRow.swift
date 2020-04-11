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
    case loading
    case header
    case title
    case button
    case paragraph
    case heading
    case comic
    
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
            return SHHereosCollectionViewCell.self
        case .loading:
            return SHLoadingCollectionViewCell.self
        case .header:
            return SHHeaderCollectionViewCell.self
        case .title, .paragraph, .heading:
            return SHLabelCollectionViewCell.self
        case .button:
            return SHButtonCollectionViewCell.self
        case .comic:
            return SHComicsCollectionViewCell.self
        }
    }
}

// MARK: -

struct SHRow<T> {
    
    // MARK: - Properties
    
    let type: SHRowType
    let data: T
    
    // MARK: - Initialiser
    
    init(_ type: SHRowType, data: T) {
        self.type = type
        self.data = data
    }
}
