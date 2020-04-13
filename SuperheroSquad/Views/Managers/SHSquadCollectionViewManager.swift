//
//  SHSquadCollectionViewManager.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import SHCore
import SHData
import UIKit

protocol SHSquadCollectionViewManagerDelegate: class {
    
    // MARK: - SHHeroesCollectionViewManagerDelegate
    
    func manager(_ collectionViewManager: SHSquadCollectionViewManager, didSelectHero hero: SHCharacter, in cell: SHSquadCollectionViewCell)
}

final class SHSquadCollectionViewManager: NSObject {

    // MARK: - UIConstants
    
    fileprivate enum UIConstants {
        static let height: CGFloat = 110.0
        static let aspectRatio: CGFloat = 0.615
    }

    // MARK: - properties
    
    weak var delegate: SHSquadCollectionViewManagerDelegate?
    private let collectionView: UICollectionView
    private let viewModel: SHHeroesViewModel
    fileprivate var dataSource: [SHCharacter] {
        return viewModel.squad.compactMap{ $0.asSquadCharacter }
    }
    
    // MARK: - Initializer
    
    init(viewModel: SHHeroesViewModel, collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        super.init()
        setupCollectionView()
    }
    
    // MARK: - Setup
    
    private func setupCollectionView() {
        [SHRowType.squad].forEach { collectionView.registerNib($0) }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
    }
}

// MARK: -

extension SHSquadCollectionViewManager: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = dataSource[safe: indexPath.row] else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(.squad, for: indexPath) as? SHSquadCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(name: item.name, url: item.thumbnail.url)
        return cell
    }
}

// MARK: -

extension SHSquadCollectionViewManager: UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let item = dataSource[safe: indexPath.row],
            let cell = collectionView.cellForItem(at: indexPath) as? SHSquadCollectionViewCell else
               { return }
        delegate?.manager(self, didSelectHero: item, in: cell)
    }

}

// MARK: -

extension SHSquadCollectionViewManager: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIConstants.height * UIConstants.aspectRatio
        return CGSize(width: width, height: UIConstants.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }

}
