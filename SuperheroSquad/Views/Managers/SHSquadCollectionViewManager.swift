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

final class SHSquadCollectionViewManager: NSObject {

    // MARK: - UIConstants
    
    fileprivate enum UIConstants {

    }

    // MARK: - properties
    
    private let collectionView: UICollectionView
    fileprivate var dataSource: [SHRow<SHCharacter>] = []
    
    // MARK: - Initializer
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        setupCollectionView()
    }
    
    // MARK: - Setup
    
    private func setupCollectionView() {
        [SHRowType.squad].forEach { collectionView.registerNib($0) }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .brandPrimary
    }
    
    // MARK: -
       
    func rebuildDataSource(with width: CGFloat, heroes: [SHCharacter]) {
       
    }
    
    // MARK: - Internal functions
       
    fileprivate func height(at indexPath: IndexPath, width: CGFloat) -> CGFloat {
        return UITableView.automaticDimension
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
        switch item.type {
        case .squad:
            guard let cell = collectionView.dequeueReusableCell(.squad, for: indexPath) as? SHSquadCollectionViewCell else { return UICollectionViewCell() }
            return cell
        default: return UICollectionViewCell()
        }
    }
}

// MARK: -

extension SHSquadCollectionViewManager: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: height(at: indexPath, width: collectionView.frame.width))
    }

}
