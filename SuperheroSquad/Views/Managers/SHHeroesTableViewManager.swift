//
//  SHHeroesTableViewManager.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

final class SHHeroesTableViewManager: NSObject {
    
    // MARK: - UI Constants
    
    enum UIConstants {
        static let cellIdentifier = "HEROESCellID"
    }
    
    // MARK: - Properties
    
    private let tableView: UITableView
    fileprivate var dataSource = [SHRow<SHCharacter>]()
    
    // MARK: - Initializer

    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        setupTableView()
    }
    
    // MARK: - Private functions
    
    fileprivate func setupTableView() {
        [SHRowType.heroes].forEach { tableView.registerNib($0) }
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .brandPrimary
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .brandSecondary
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        refreshTableView()
    }
 
    private func refreshTableView() {
        let bottomInset: CGFloat = {
            let headerHeight = tableView.frame.height
            let contentHeight = tableView.rowHeight
            let threshold = contentHeight + headerHeight - tableView.bounds.height
            guard threshold > 0 else { return 0.0 }
            return tableView.bounds.height - contentHeight
        }()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
    }
    
    // MARK: -
    
    func rebuildDataSource(with width: CGFloat, heroes: [SHCharacter]) {
        
    }
    
    // MARK: - Internal functions
    
    fileprivate func height(at indexPath: IndexPath, width: CGFloat) -> CGFloat {
        return UITableView.automaticDimension
    }
    
   
}

// MARK: - UITableViewDataSource

extension SHHeroesTableViewManager: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = dataSource[safe: indexPath.row] else { return UITableViewCell() }
        switch item.type {
        case .heroes:
            guard let cell = tableView.dequeueReusableCell(.squad, for: indexPath) as? SHHeroesTableViewCell else { return UITableViewCell() }
            return cell
        default: return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate

extension SHHeroesTableViewManager: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height(at: indexPath, width: tableView.frame.width)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard  let item = dataSource[safe: indexPath.row] else { return }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

