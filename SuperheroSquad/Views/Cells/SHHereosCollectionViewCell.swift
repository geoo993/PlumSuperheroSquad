//
//  SHHereosCollectionViewCell.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 10/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import SHCore
import SHData
import TransitionAnimation

final class SHHereosCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Constants
    
    enum UIConstants {
        static let padding: CGFloat = 15
        static let titleHeight: CGFloat = 60
        static let aspectRatio: CGFloat = 1.272
        static let cornerRadius: CGFloat = 10
        static let background: UIColor = .brandSecondary
        static let titleTextColor: UIColor = .brandWhite
        static let titleFont = SHFontStyle.marvel(20).font
        static let gradientLayerKey = "gradientLayerKey"
    }

    // MARK: - IBOutlet properties
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    var layers: [String: CALayer] = [:]
    
    // MARK: - UICollectionViewCell life cycle

    override func awakeFromNib() {
      super.awakeFromNib()
      setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let gradientLayer = layers[UIConstants.gradientLayerKey] else { return }
        gradientLayer.frame = self.bounds
        gradientLayer.frame.origin.y -= bounds.height
    }
   
    // MARK: - Setup

    private func setupUI() {
        
        backgroundColor = UIConstants.background
        
        roundCorners(withRadius: UIConstants.cornerRadius)
        titleLabel.textColor = UIConstants.titleTextColor
        titleLabel.font = UIConstants.titleFont
        layers[UIConstants.gradientLayerKey] = setupGradient(in: containerView, with: [UIColor.clear.cgColor, UIConstants.background.cgColor])
        containerView.roundCorners(withRadius: UIConstants.cornerRadius)
        containerView.backgroundColor = UIConstants.background
        containerView.clipsToBounds = true
        containerView.bringSubviewToFront(titleLabel)
    }

    // MARK: - Cell configuration

    func configure(image: SHImageResource, name: String, description: String) {
        backgroundImage.setImage(with: image.url)
        titleLabel.text = name
    }
    
    // MARK: Gestures
    
    // Make it appears very responsive to touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
}

// MARK: -

extension SHHereosCollectionViewCell {
    
    // MARK: - Sizing
    
    static func height(forWidth width: CGFloat, name: String) -> CGFloat {
    
        return width * UIConstants.aspectRatio
    }
}

// MARK: -

extension SHHereosCollectionViewCell: CardCollectionViewCell {
    
    // MARK: - Transition
    
    var cardContentView: UIView {
        get {
            return containerView
        }
    }
    
}
