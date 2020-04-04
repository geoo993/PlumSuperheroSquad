//
//  SHSquadCollectionViewCell.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

final class SHSquadCollectionViewCell: UICollectionViewCell {

  
    // MARK: - UI Constants

    enum UIConstants {
        
    }

    // MARK: - IBOutlet properties

    
    // MARK: - UICollectionViewCell life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
    }
    
    // MARK: - Cell configuration
    
    func configure(name: String) {
       
    }
  
}

// MARK: -

extension SHSquadCollectionViewCell {
    
    // MARK: - Sizing
    
    static func height(forWidth width: CGFloat, name: String) -> CGFloat {
        return 0.0
    }
}
