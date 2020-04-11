//
//  SHHeaderCollectionViewCell.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 10/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import SHCore

final class SHHeaderCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Constants
    
    enum UIConstants {
        static let background = UIColor.brandSecondary
        static let cornerRadius: CGFloat = 10
        static let gradientLayerKey = "gradientLayerKey"
        static let aspectRatio: CGFloat = 1.272
    }

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
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
    
    // MARK: - UI Setup
    
    private func setupUI() {
        backgroundColor = UIConstants.background
        containerView.backgroundColor = UIConstants.background
        containerView.clipsToBounds = true
        containerView.roundCorners(withRadius: UIConstants.cornerRadius)
        layers[UIConstants.gradientLayerKey] = setupGradient(in: containerView, with: [UIColor.clear.cgColor, UIConstants.background.cgColor])
    }
    
    // MARK: - Configuration
    
    func configure(with image: URL) {
        imageView.setImage(with: image)
    }

}

extension SHHeaderCollectionViewCell {
    
    // MARK: - Sizing
    
    static func height(forWidth width: CGFloat) -> CGFloat {
        
        return width * UIConstants.aspectRatio
    }
}
