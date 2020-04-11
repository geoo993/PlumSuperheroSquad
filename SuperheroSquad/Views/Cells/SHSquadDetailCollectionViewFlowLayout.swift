//
//  SHSquadDetailCollectionViewFlowLayout.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 11/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

final class SHSquadDetailCollectionViewFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Layout
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        layoutAttributes?.forEach { attributes in
            
            // modify header
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader,
                let collectioView = collectionView, attributes.indexPath.section == 0 {
                let width = collectioView.frame.width
                let contentOffset = collectioView.contentOffset.y
                if contentOffset > 0 { return }
                let height = attributes.frame.height - contentOffset
                attributes.frame = CGRect(x: 0, y: contentOffset, width: width, height: height)
            }
        }
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // MARK: - UICollectionViewCell life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollDirection = .vertical
        
    }
}
