//
//  SHSquadDetailCollectionViewManager.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 10/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import SHCore
import SHData
import UIKit

protocol SHSquadDetailCollectionViewManagerDelegate: class {
    
    // MARK: - SHHeroesCollectionViewManagerDelegate
    
    func manager(_ collectionViewManager: SHSquadDetailCollectionViewManager, didFireHeroFromSquad hero: SHCharacter)
    func manager(_ collectionViewManager: SHSquadDetailCollectionViewManager, didSelectComic comic: SHComic)
}


final class SHSquadDetailCollectionViewManager: NSObject {

    // MARK: - UIConstants
    
    fileprivate enum UIConstants {
        static let background = UIColor.brandPrimary
        static let padding: CGFloat = 15
    }

    // MARK: - Cell Type
    
    enum CellType {
        case title(String)
        case button(SHSquadDetailViewModel.SquadStatus)
        case paragraph(String)
        case heading(String)
        case comic(SHComic?, SHComic?)
    }
    
    // MARK: - properties

    private let collectionView: UICollectionView
    private let viewModel: SHSquadDetailViewModel
    fileprivate var dataSource: [SHRow<CellType>] {
        var data = [SHRow<CellType>]()
        data.append(SHRow(.title, data: CellType.title(viewModel.character.name)))
        data.append(SHRow(.button, data: CellType.button(viewModel.status)))
        data.append(SHRow(.paragraph, data: CellType.paragraph(viewModel.character.description)))
        let comicsPaired = viewModel.comics.tuple()
        if comicsPaired.count > 0 {
            data.append(SHRow(.heading, data: CellType.heading("squad_detail__last_appeared".localized)))
            data += comicsPaired.map{ SHRow(.paragraph, data: CellType.comic($0.0, $0.1)) }
        }
        return data
    }
    weak var delegate: SHSquadDetailCollectionViewManagerDelegate?
    
    // MARK: - Initializer
    
    init(viewModel: SHSquadDetailViewModel, collectionView: UICollectionView) {
        self.viewModel = viewModel
        self.collectionView = collectionView
        super.init()
        setupViewLayout()
        setup(collectionView)
    }
    
    // MARK: - Setup
    
    private func setup(_ collectionView: UICollectionView) {
        [.title, .button, .paragraph, .heading, .comic].forEach { collectionView.registerNib($0) }
        collectionView.registerHeaderNib(.header)
        collectionView.registerFooterNib(.loading)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIConstants.background
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupViewLayout() {
        if let layout = collectionView.collectionViewLayout as? SHSquadDetailCollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: UIConstants.padding, left: UIConstants.padding, bottom: UIConstants.padding, right: UIConstants.padding)
            
        }
    }
 
    // MARK: - Internal functions
       
    fileprivate func height(at indexPath: IndexPath, width: CGFloat) -> CGFloat {
        guard let item = dataSource[safe: indexPath.row] else { return 0 }
        switch item.data {
        case .title(let text): return SHLabelCollectionViewCell.height(forWidth: width, type: .title, text: text)
        case .button(let status): return SHButtonCollectionViewCell.height(forWidth: width, title: status.value)
        case .paragraph(let text): return SHLabelCollectionViewCell.height(forWidth: width, type: .paragraph, text: text)
        case .heading(let text): return SHLabelCollectionViewCell.height(forWidth: width, type: .heading, text: text, enableBottomSpacing: false)
        case .comic(let left, let right): return SHComicsCollectionViewCell.height(forWidth: width, leftTitle: left?.title, rightTitle: right?.title)
        }
    }

}

// MARK: -

extension SHSquadDetailCollectionViewManager: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = dataSource[safe: indexPath.row] else { return UICollectionViewCell() }
        switch item.data {
        case .title(let text):
            guard let cell = collectionView.dequeueReusableCell(.title, for: indexPath) as? SHLabelCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: .title, text: text)
            return cell
        case .button(let status):
            guard let cell = collectionView.dequeueReusableCell(.button, for: indexPath) as? SHButtonCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with:  status)
            return cell
        case .paragraph(let text):
            guard let cell = collectionView.dequeueReusableCell(.paragraph, for: indexPath) as? SHLabelCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: .paragraph, text: text)
            return cell
        case .heading(let text):
            guard let cell = collectionView.dequeueReusableCell(.heading, for: indexPath) as? SHLabelCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: .heading, text: text)
            return cell
        case .comic(let left, let right):
            guard let cell = collectionView.dequeueReusableCell(.comic, for: indexPath) as? SHComicsCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(leftImage: left?.thumbnail.url, leftTitle: left?.title,
                           rightImage: right?.thumbnail.url, rightTitle: right?.title)
            return cell
        }
    }
}

// MARK: -

extension SHSquadDetailCollectionViewManager: UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
// MARK: -

extension SHSquadDetailCollectionViewManager: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - (UIConstants.padding * 2)
        return CGSize(width: width, height: height(at: indexPath, width: width))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: SHHeaderCollectionViewCell.height(forWidth: collectionView.frame.width))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            guard let view = collectionView.dequeueReusableSupplementaryView(.header, with: kind, for: indexPath) as? SHHeaderCollectionViewCell else { return UICollectionReusableView() }
            view.configure(with: viewModel.character.thumbnail.url)
            return view
        } else {
            return collectionView.dequeueReusableSupplementaryView(.loading, with: kind, for: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        
    }
    
}
