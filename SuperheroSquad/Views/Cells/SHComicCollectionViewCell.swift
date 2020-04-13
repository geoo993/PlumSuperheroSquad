//
//  SHComicCollectionViewCell.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 12/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import SHCore
import TransitionAnimation

final class SHComicCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Constants
    
    enum UIConstants {
        static let background = UIColor.brandPrimary
        static let textColor = UIColor.brandWhite
        static let borderColor = UIColor.brandWhite
        static let borderWidth: CGFloat = 0.4
        static let cornerRadius: CGFloat = 4.0
    }
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: - UICollectionViewCell life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        backgroundColor = UIConstants.background
        containerView.clipsToBounds = true
        imageView.roundCorners(withRadius: UIConstants.cornerRadius)
        imageView.setBorder(width: UIConstants.borderWidth, color: UIConstants.borderColor)
        titleLabel.textColor = UIConstants.textColor
        titleLabel.font = SHComicsCollectionViewCell.UIConstants.textFont
    }
    
    // MARK: - Configuration
    
    func configure(image: URL, title: String) {
        imageView.setImage(with: image)
        titleLabel.text = title
    }

}

extension SHComicCollectionViewCell: CardCollectionViewCell {
    
    var cardContentView: UIView {
        get {
            return containerView
        }
    }
    
}
