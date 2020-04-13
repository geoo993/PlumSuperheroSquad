//
//  SHSquadCollectionViewCell.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import SHCore

final class SHSquadCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Constants

    enum UIConstants {
        static let textFont: UIFont = SHFontStyle.marvel(12).font(scalable: false)
        static let textColor = UIColor.brandWhite
    }

    // MARK: - IBOutlet properties
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - UICollectionViewCell life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.roundCorners()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        containerView.clipsToBounds = true
        titleLabel.textColor = UIConstants.textColor
        titleLabel.font = UIConstants.textFont
    }
    
    // MARK: - Cell configuration
    
    func configure(name: String, url: URL) {
        imageView.setImage(with: url)
        titleLabel.text = name
    }
  
}
