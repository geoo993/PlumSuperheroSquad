//
//  SHComicsCollectionViewCell.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 10/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import SHCore
import SHData
import TransitionAnimation

final class SHComicsCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Constants
    
    enum UIConstants {
        static let background = UIColor.brandPrimary
        static let textFont: UIFont = SHFontStyle.subhead.font(scalable: false)
        static let contentMargin: CGFloat = 15.0
        static let imageHorizontalSpacing: CGFloat = 20.0
        static let imageVerticalSpacing: CGFloat = 8.0
        static let imagesAspectRatio: CGFloat = 1.41
    }
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    fileprivate var dataSource: [SHRow<SHComic>] = []
    typealias ComicData = (comic: SHComic, cell: SHComicCollectionViewCell, indexPath: IndexPath)
    var onTapComic: ((ComicData) -> Void)?
    
    // MARK: - UICollectionViewCell life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        backgroundColor = UIConstants.background
        collectionView.registerNib(.comic)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIConstants.background
        collectionView.contentInsetAdjustmentBehavior = .never
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = UIConstants.imageHorizontalSpacing
        }
    }
    
    // MARK: - Configuration
    
    func configure(leftComic: SHComic?, rightComic: SHComic?) {
        dataSource = [leftComic, rightComic].compactMap{ $0 }.map { SHRow(.comic, data: $0) }
        collectionView.reloadData()
    }

}

// MARK: -

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

// MARK: -

extension SHComicsCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = dataSource[safe: indexPath.row] else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(item.type, for: indexPath) as? SHComicCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(image: item.data.thumbnail.url, title: item.data.title)
        return cell
    }
    

    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let item = dataSource[safe: indexPath.row],
            let cell = collectionView.cellForItem(at: indexPath) as? SHComicCollectionViewCell
            else { return }
        onTapComic?((item.data, cell, indexPath))
    }

}

// MARK: -

extension SHComicsCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (frame.width - UIConstants.imageHorizontalSpacing) / 2
        return CGSize(width: width, height: collectionView.frame.height)
    }
}
