//
//  SHLabelCollectionViewCell.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 10/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import SHCore

final class SHLabelCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Constants
    
    enum UIConstants {
        static let background = UIColor.brandPrimary
        static let textColor = UIColor.brandWhite
        static let contentMargin: CGFloat = 15.0
    }
    
    // MARK: - LabelType
    
    enum LabelType {
        case title
        case paragraph
        case heading
        case more
    }
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    
    // MARK: - UICollectionViewCell life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        backgroundColor = UIConstants.background
    }
    
    // MARK: - Configuration
    
    func configure(with type: LabelType, text: String) {
        label.text = text
        label.font = SHLabelCollectionViewCell.font(of: type)
        label.textAlignment = SHLabelCollectionViewCell.textAlignment(of: type)
        label.textColor = UIConstants.textColor
    }
    
    static func font(of type: LabelType) -> UIFont {
        switch type {
        case .title: return SHFontStyle.title1.font
        case .paragraph: return SHFontStyle.body.font
        case .heading: return SHFontStyle.title3.font
        case .more: return SHFontStyle.body.font
        }
    }
    
    static func textAlignment(of type: LabelType) -> NSTextAlignment {
        switch type {
        case .title, .paragraph, .heading: return .left
        case .more: return .center
        }
    }

}

extension SHLabelCollectionViewCell {
    
    // MARK: - Sizing
    
    static func height(forWidth width: CGFloat, type: LabelType, text: String, enableBottomSpacing: Bool = true) -> CGFloat {
        
        if text.isEmpty {
            return 0.0
        }
        let titleFont = font(of: type)
        let spacing = enableBottomSpacing ? UIConstants.contentMargin * 2 : UIConstants.contentMargin
        return text.heightWithConstrainedWidth(width: width, font: titleFont) + spacing
    }
}
