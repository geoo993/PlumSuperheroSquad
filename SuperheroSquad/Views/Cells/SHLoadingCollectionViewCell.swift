//
//  SHLoadingCollectionViewCell.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 10/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

final class SHLoadingCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Constants
    
    enum UIConstants {
        static let cellHeight: CGFloat = 44
        static let spinnerColor = UIColor.brandSecondary
    }
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    // MARK: - Properties
    
    var isAnimating: Bool = false
    var currentTransform: CGAffineTransform?
    
    // MARK: - UICollectionViewCell life cycle

    override func awakeFromNib() {
      super.awakeFromNib()
      setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .clear
        spinner.color = UIConstants.spinnerColor
        prepareInitialAnimation()
    }
    
    // MARK: - Animations
    
    func setTransform(inTransform: CGAffineTransform, scaleFactor: CGFloat) {
        if isAnimating {
            return
        }
        currentTransform = inTransform
        spinner?.transform = CGAffineTransform.init(scaleX: scaleFactor, y: scaleFactor)
    }
    
    func prepareInitialAnimation() {
        isAnimating = false
        spinner?.stopAnimating()
        spinner?.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
    }
    
    func startAnimation() {
        isAnimating = true
        spinner?.transform = CGAffineTransform.identity
        spinner?.startAnimating()
    }
    
    func stopAnimation() {
        isAnimating = false
        spinner?.stopAnimating()
    }
    
    func startLoadingAnimation() {
        if isAnimating {
            return
        }
        isAnimating = true
        UIView.animate(withDuration: 0.2) { [weak self] () in
            self?.spinner?.transform = CGAffineTransform.identity
        }
    }
}
