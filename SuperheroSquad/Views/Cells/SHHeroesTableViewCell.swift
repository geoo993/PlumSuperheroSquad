//
//  SHHeroesTableViewCell.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import SHCore
import SHData
import UIKit

final class SHHeroesTableViewCell: UITableViewCell {

    // MARK: - UI Constants
    
    enum UIConstants {
        static let padding: CGFloat = 10
        static let cellHeight: CGFloat = 150
        static let background: UIColor = .brandSecondary
        static let titleTextColor: UIColor = .brandWhite
        static let titleFont = SHFontStyle.marvel(20).font
    }
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
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
        backgroundColor = UIConstants.background
        tintColor = UIConstants.titleTextColor
        titleLabel.textColor = UIConstants.titleTextColor
        titleLabel.font = UIConstants.titleFont
    }
    
    // MARK: - Configuration
    
    func configure(image: SHImageResource, name: String, description: String) {
        heroImageView.setImage(with: image.url)
        titleLabel.text = name
    }

}

extension SHHeroesTableViewCell {
    
    // MARK: - Sizing
    
    static func height(forWidth width: CGFloat, name: String) -> CGFloat {
        
        return UIConstants.cellHeight
    }
}
