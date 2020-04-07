//
//  SHHeroesTableViewManager.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import SHCore
import SHData
import UIKit

protocol SHHeroesTableViewManagerDelegate: class {
    
    // MARK: - SHCharactersViewModelDelegate
    
    func didSelectHero(_ tableViewManager: SHHeroesTableViewManager, selectedHero hero: SHCharacter)
}

final class SHHeroesTableViewManager: NSObject {
    
    // MARK: - UI Constants
    
    enum UIConstants {
        static let background = UIColor.brandPrimary
        static let separatorColor = UIColor.brandSecondary
        static let cellSpacing: CGFloat = 10.0
    }
    
    // MARK: - Properties
    
    var tableView: UITableView? {
        didSet { setupTableView() }
    }
    private let viewModel: SHHeroesViewModel
    fileprivate var dataSource: [SHCharacter] { return viewModel.characters }
    weak var delegate: SHHeroesTableViewManagerDelegate?
        
    // MARK: - Initializer

    init(viewModel: SHHeroesViewModel) {
        self.viewModel = viewModel
        super.init()
        setupTableView()
    }
    
    // MARK: - Private functions
    
    fileprivate func setupTableView() {
        guard let tableView = tableView else { return }
        [.heroes, .loading].forEach { tableView.registerNib($0) }
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.fixContentInsetAdjustmentBehavior()
    }
 
    // MARK: - Internal functions
    
    fileprivate func height(at indexPath: IndexPath, width: CGFloat) -> CGFloat {
        guard let item = dataSource[safe: indexPath.section] else { return UITableView.automaticDimension }
        switch indexPath.row {
        case 0: return SHHeroesTableViewCell.height(forWidth: width, name: item.name)
        case 1: return SHLoadingTableViewCell.UIConstants.cellHeight
        default: return UITableView.automaticDimension
        }
    }
    
}

// MARK: - UITableViewDataSource

extension SHHeroesTableViewManager: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldShowLoadingcell(with: section) ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height(at: indexPath, width: tableView.frame.width)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard
                let item = dataSource[safe: indexPath.section],
                let cell = tableView.dequeueReusableCell(.heroes, for: indexPath) as? SHHeroesTableViewCell else
            { return UITableViewCell() }
            cell.configure(image: item.thumbnail, name: item.name, description: item.description)
            cell.selectionStyle = .default
            cell.accessoryType = .disclosureIndicator
            cell.accessoryView = UIImageView(image: UIImage(named: "chevron"))
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(.loading, for: indexPath) as? SHLoadingTableViewCell else
            { return UITableViewCell() }
            cell.spinner.startAnimating()
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UIConstants.cellSpacing
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.backgroundColor = .clear
    }
}

// MARK: - UITableViewDelegate

extension SHHeroesTableViewManager: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource[safe: indexPath.section] else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectHero(self, selectedHero: item)
    }
}

// MARK: -

extension SHHeroesTableViewManager {
    
    // MARK: - Pagination
    
    func shouldShowLoadingcell(with section: Int) -> Bool {
        guard
            let pagination = viewModel.pagination,
            section == pagination.itemsToLoadIndexed && viewModel.isLoadingNextPage
            else { return false }
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let pagination = viewModel.pagination else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if viewModel.isLoadingNextPage == false {
                viewModel.reload(type: .nextPage)
                
                if viewModel.isLoadingNextPage {
                    tableView?.reloadSections(IndexSet(integer: pagination.itemsToLoadIndexed), with: .none)
                }
            }
        }
    }
    
    // Pagination two
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       /*
        let currentOffset = scrollView.contentOffset.y + scrollView.bounds.height
        let percentage = currentOffset/scrollView.contentSize.height
        
        if percentage >= 0.75 {
            viewModel.reload(type: .nextPage)
        }
        */
    }
}
