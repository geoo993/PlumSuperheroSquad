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
    
    func manager(_ collectionViewManager: SHSquadDetailCollectionViewManager, didSelectComic comic: SHComic,
                 in cell: SHComicCollectionViewCell, at position: SHSquadDetailCollectionViewManager.SHComicPosition)
    func manager(_ collectionViewManager: SHSquadDetailCollectionViewManager, didFire character: SHCharacter, with status: SHSquadStatus)
}


final class SHSquadDetailCollectionViewManager: NSObject {

    // MARK: - UIConstants
    
    fileprivate enum UIConstants {
        static let background = UIColor.brandPrimary
        static let bottomPullThreshold: Float = 100
        static let padding: CGFloat = 15
    }

    // MARK: - Cell Type
    
    enum SHComicPosition {
        case left
        case right
    }
    
    enum CellType {
        case title(String)
        case button(SHSquadStatus)
        case paragraph(String)
        case heading(String)
        case comics(SHComic, SHComic?)
        case more(String)
    }
    
    // MARK: - properties

    private let collectionView: UICollectionView
    private let viewModel: SHSquadDetailViewModel
    private var footerView: SHLoadingCollectionViewCell?
    fileprivate var dataSource: [SHRow<CellType>] {
        var data = [SHRow<CellType>]()
        data.append(SHRow(.title, data: CellType.title(viewModel.character.name)))
        data.append(SHRow(.button, data: CellType.button(viewModel.status)))
        data.append(SHRow(.paragraph, data: CellType.paragraph(viewModel.character.description)))
        let comicsPaired = viewModel.comics.tuple()
        if comicsPaired.count > 0 {
            data.append(SHRow(.heading, data: CellType.heading("squad_detail__last_appeared".localized)))
            data += comicsPaired.map{ SHRow(.comics, data: CellType.comics($0.0, $0.1)) }
        }
        if viewModel.otherComics > 0 {
            data.append(SHRow(.more, data: CellType.more(String(format: "squad_detail__other_comic".localized, "\(viewModel.otherComics)") )))
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
        [.title, .button, .paragraph, .heading, .comics, .more].forEach { collectionView.registerNib($0) }
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
        case .comics(let left, let right): return SHComicsCollectionViewCell.height(forWidth: width, leftTitle: left.title, rightTitle: right?.title)
        case .more(let text): return SHLabelCollectionViewCell.height(forWidth: width, type: .more, text: text)
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
            guard let cell = collectionView.dequeueReusableCell(item.type, for: indexPath) as? SHLabelCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: .title, text: text)
            return cell
        case .button(let status):
            guard let cell = collectionView.dequeueReusableCell(item.type, for: indexPath) as? SHButtonCollectionViewCell else { return UICollectionViewCell() }
            let character = viewModel.character
            cell.configure(with:  status)
            cell.onTapStatus = { [weak self] () in
                guard let self = self else { return }
                self.delegate?.manager(self, didFire: character, with: status)
            }
            return cell
        case .paragraph(let text):
            guard let cell = collectionView.dequeueReusableCell(item.type, for: indexPath) as? SHLabelCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: .paragraph, text: text)
            return cell
        case .heading(let text):
            guard let cell = collectionView.dequeueReusableCell(item.type, for: indexPath) as? SHLabelCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: .heading, text: text)
            return cell
        case .comics(let itemOne, let itemTwo):
            guard let cell = collectionView.dequeueReusableCell(item.type, for: indexPath) as? SHComicsCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(leftComic: itemOne, rightComic: itemTwo)
            cell.onTapComic = { [weak self] data in
                guard let self = self else { return }
                self.delegate?.manager(self, didSelectComic: data.comic, in: data.cell, at: (data.indexPath.row == 0) ? .left : .right)
            }
            return cell
        case .more(let text):
            guard let cell = collectionView.dequeueReusableCell(item.type, for: indexPath) as? SHLabelCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: .more, text: text)
            return cell
        }
    }
}

// MARK: -

extension SHSquadDetailCollectionViewManager: UICollectionViewDelegate {
    
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
        if percentage >= 0.8 {
            viewModel.reload(type: .nextPage)
            if viewModel.isLoadingNextPage {
                footer.startAnimation()
            } else  {
                footer.stopAnimation()
            }
        }
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
        if let pagination = viewModel.pagination, pagination.isNextListAvailable == false {
            return CGSize.zero
        }
        let width = collectionView.frame.width - (UIConstants.padding * 2) - 5
        return CGSize(width: width, height: SHLoadingCollectionViewCell.UIConstants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(.header, with: kind, for: indexPath)
            guard let header = view as? SHHeaderCollectionViewCell else { return view }
            header.configure(with: viewModel.character.thumbnail.url)
            return header
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(.loading, with: kind, for: indexPath)
            guard let footer = view as? SHLoadingCollectionViewCell else { return UICollectionReusableView() }
            footer.backgroundColor = .clear
            footerView = footer
            return footer
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
