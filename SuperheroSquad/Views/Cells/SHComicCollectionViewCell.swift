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
    
    // MARK: - Properties
    private let generator = UIImpactFeedbackGenerator()
    
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

    // MARK: Gestures
    
    // Make it appears very responsive to touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        generator.prepare()
        generator.impactOccurred()
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

extension SHComicCollectionViewCell: CardCollectionViewCell {
    
    var cardContentView: UIView {
        get {
            return containerView
        }
    }
    
}
