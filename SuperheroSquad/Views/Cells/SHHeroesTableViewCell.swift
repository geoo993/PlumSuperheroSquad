//
//  SHHeroesTableViewCell.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

final class SHHeroesTableViewCell: UITableViewCell {

    // MARK: - UI Constants
    
    enum UIConstants {
        
    }
    
    // MARK: - IBOutlet Properties
    
    
    // MARK: - Properties
    
    
    // MARK: - UICollectionViewCell life cycle
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        
    }
    
    // MARK: - Configuration
    
    func configure(name: String) {
        
    }

}

extension SHHeroesTableViewCell {
    
    // MARK: - Sizing
    
    static func height(forWidth width: CGFloat, name: String) -> CGFloat {
        
        return 0.0
    }
}
