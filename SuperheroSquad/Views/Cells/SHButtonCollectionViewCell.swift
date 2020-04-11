//
//  SHButtonCollectionViewCell.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 10/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import SHCore

final class SHButtonCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Constants
    
    enum UIConstants {
        static let background = UIColor.brandPrimary
        static let textColor = UIColor.brandWhite
        static let textFont: UIFont = SHFontStyle.headline.font
        static let borderColor = UIColor.brandRed
        static let borderWidth: CGFloat = 2
        static let cornerRadius: CGFloat = 8
        static let margin: CGFloat = 15.0
    }
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var button: UIButton!
    
    // MARK: - UICollectionViewCell life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
 
    // MARK: - Configuration
    
    func configure(with status: SHSquadDetailViewModel.SquadStatus) {
        backgroundColor = status == SHSquadDetailViewModel.SquadStatus.hired ? UIConstants.background : UIConstants.borderColor
        button.titleLabel?.font = UIConstants.textFont
        button.setTitleColor(UIConstants.textColor, for: .normal)
        button.setTitle(status.value, for: .normal)
        roundCorners(withRadius: UIConstants.cornerRadius)
        setBorder(width: UIConstants.borderWidth, color: UIConstants.borderColor)
    }
}

extension SHButtonCollectionViewCell {
    
    // MARK: - Sizing
    
    static func height(forWidth width: CGFloat, title: String) -> CGFloat {
        return title.heightWithConstrainedWidth(width: width, font: UIConstants.textFont) + (UIConstants.margin * 2)
    }
    
}
