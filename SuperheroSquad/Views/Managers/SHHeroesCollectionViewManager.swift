//
//  SHHeroesCollectionViewManager.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import SHCore
import SHData
import UIKit

protocol SHHeroesCollectionViewManagerDelegate: class {
    
    // MARK: - SHHeroesCollectionViewManagerDelegate
    
    func didSelectHero(_ collectionViewManager: SHHeroesCollectionViewManager, didSelectHero hero: SHCharacter, in cell: SHHereosCollectionViewCell)
}

final class SHHeroesCollectionViewManager: NSObject {
    
    // MARK: - UI Constants
    
    enum UIConstants {
        static let background = UIColor.brandPrimary
        static let separatorColor = UIColor.brandSecondary
        static let cellSpacing: CGFloat = 10.0
        static let bottomPullThreshold: Float = 100
    }
    
    // MARK: - Properties
    
    let collectionView: UICollectionView
    var footerView: SHLoadingCollectionViewCell?
    private let viewModel: SHHeroesViewModel
    fileprivate var dataSource: [SHCharacter] { return viewModel.characters }
    weak var delegate: SHHeroesCollectionViewManagerDelegate?
        
    // MARK: - Initializer

    init(viewModel: SHHeroesViewModel, collectionView: UICollectionView) {
        self.viewModel = viewModel
        self.collectionView = collectionView
        super.init()
        setupCollectionView()
    }
    
    // MARK: - Helper Functions
    
    func setupCollectionView() {
        collectionView.registerNib(.heroes)
        collectionView.registerFooterNib(.loading)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        
    }
    
    func height(at indexPath: IndexPath, width: CGFloat) -> CGFloat {
        guard let item = dataSource[safe: indexPath.row] else { return UITableView.automaticDimension }
        return SHHereosCollectionViewCell.height(forWidth: width, name: item.name)
    }
}

// MARK: -

extension SHHeroesCollectionViewManager: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = dataSource[safe: indexPath.row],
            let cell = collectionView.dequeueReusableCell(.heroes, for: indexPath) as? SHHereosCollectionViewCell
            else { return UICollectionViewCell() }
        cell.configure(image: item.thumbnail, name: item.name, description: item.description)
        return cell
    }
    
}

// MARK: -

extension SHHeroesCollectionViewManager: UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let item = dataSource[safe: indexPath.row],
            let cell = collectionView.cellForItem(at: indexPath) as? SHHereosCollectionViewCell else
               { return }
        delegate?.didSelectHero(self, didSelectHero: item, in: cell)
    }
    
    // MARK: - Pagination
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentSize.height - scrollView.contentOffset.y
        var triggerThreshold  = Float((currentOffset - scrollView.bounds.size.height)) / UIConstants.bottomPullThreshold
        triggerThreshold =  min(triggerThreshold, 0.0)
        let pullRatio = min(abs(triggerThreshold), 1.0)
        
        footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1.0 {
            footerView?.startLoadingAnimation()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let footer = footerView else { return }
        let currentOffset = scrollView.contentOffset.y + scrollView.bounds.height
        let percentage = currentOffset / scrollView.contentSize.height
        if percentage >= 0.8 || footer.isAnimating {
            footer.startAnimation()
            viewModel.reload(type: .nextPage)
            if viewModel.isLoadingNextPage == false {
                footer.stopAnimation()
            }
        }
    }

}

// MARK: -

extension SHHeroesCollectionViewManager: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: height(at: indexPath, width: collectionView.frame.width))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let pagination = viewModel.pagination, pagination.isNextListAvailable == false {
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: SHLoadingCollectionViewCell.UIConstants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionFooter {
            guard let view = collectionView.dequeueReusableSupplementaryView(.loading, with: kind, for: indexPath) as? SHLoadingCollectionViewCell else { return UICollectionReusableView() }
            view.backgroundColor = .clear
            footerView = view
            return view
        } else {
            return collectionView.dequeueReusableSupplementaryView(.loading, with: kind, for: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            footerView?.stopAnimation()
        }
    }
    
}
