//
//  UICollectionView+Ext.swift
//  SHCore
//
//  Created by GEORGE QUENTIN on 11/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    override open func snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView? {
          return super.snapshotView(afterScreenUpdates: true)
    }
    
    public func setupGradient(in container: UIView, with colors: [CGColor]) -> CALayer {
       let gradientLayer = CAGradientLayer()
       gradientLayer.colors = colors
       gradientLayer.locations = [0.7, 1]
       
       let gradientContainerView = UIView()
       container.addSubview(gradientContainerView)
       gradientContainerView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
       gradientContainerView.layer.addSublayer(gradientLayer)
       return gradientLayer
    }
}
