//
//  SHComicsCollectionViewCell.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 10/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import SHCore

final class SHComicsCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Constants
    
    enum UIConstants {
        static let background = UIColor.brandPrimary
        static let textColor = UIColor.brandWhite
        static let textFont: UIFont = SHFontStyle.subhead.font(scalable: false)
        static let borderColor = UIColor.brandWhite
        static let borderWidth: CGFloat = 4
        static let contentMargin: CGFloat = 15.0
        static let cornerRadius: CGFloat = 4.0
        static let imageHorizontalSpacing: CGFloat = 20.0
        static let imageVerticalSpacing: CGFloat = 8.0
        static let imagesAspectRatio: CGFloat = 1.41
    }
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var leftContainerView: UIView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightContainerView: UIView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var rightlabel: UILabel!
    
   
    // MARK: - UICollectionViewCell life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        backgroundColor = UIConstants.background
        leftContainerView.clipsToBounds = true
        leftImageView.roundCorners(withRadius: UIConstants.cornerRadius)
        leftImageView.setBorder(width: UIConstants.borderWidth, color: UIConstants.borderColor)
        leftLabel.textColor = UIConstants.textColor
        leftLabel.font = UIConstants.textFont
        rightContainerView.clipsToBounds = true
        rightImageView.roundCorners(withRadius: UIConstants.cornerRadius)
        rightImageView.setBorder(width: UIConstants.borderWidth, color: UIConstants.borderColor)
        rightlabel.textColor = UIConstants.textColor
        rightlabel.font = UIConstants.textFont
    }
    
    // MARK: - Configuration
    
    func configure(leftImage: URL?, leftTitle: String?, rightImage: URL?, rightTitle: String?) {
        leftLabel.text = leftTitle
        leftImageView.setImage(with: leftImage)
        rightlabel.text = rightTitle
        rightImageView.setImage(with: rightImage)
    }

}

extension SHComicsCollectionViewCell {
    
    // MARK: - Sizing
    
    static fileprivate func contentWidth(forCellWidth width: CGFloat) -> CGFloat {
        return width - UIConstants.imageHorizontalSpacing
    }
    
    static func height(forWidth width: CGFloat, leftTitle: String?, rightTitle: String?) -> CGFloat {
        let contentWidth = SHComicsCollectionViewCell.contentWidth(forCellWidth: width)
        
        let imageContainerWith = contentWidth / 2
        let imageheight = imageContainerWith * UIConstants.imagesAspectRatio
        var height = UIConstants.contentMargin + imageheight + UIConstants.imageVerticalSpacing
        
        let leftTextHeight = leftTitle?.heightWithConstrainedWidth(width: imageContainerWith, font: UIConstants.textFont) ?? 0
        let rightTextHeight = rightTitle?.heightWithConstrainedWidth(width: contentWidth, font: UIConstants.textFont) ?? 0
        height += max(leftTextHeight, rightTextHeight)
        height += UIConstants.contentMargin
        return height
    }
}
