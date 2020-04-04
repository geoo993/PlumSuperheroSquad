//
//  SHHomeViewController.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

final class SHHomeViewController: UIViewController {


    // MARK: - UIConstants
    
    enum UIConstants {
        static let backgroundTitle = "THE SQUAD WILL BE HERE SOON"
        static let backgroundFont = SHFontStyle.marvel(30).font
    }
    
    // MARK: - IBOutlet properties
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var backgroundLabel: UILabel!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var heroesCollectionView: UITableView!
    @IBOutlet private weak var heroesTableView: UITableView!
    
    // MARK: - Properties
    
    private let viewModel: SHSquadViewModel
    private var collectionViewManager: SHSquadCollectionViewManager?
    private var tableViewManager: SHHeroesTableViewManager?
    private let refreshControl = UIRefreshControl()

    // MARK: - Initializers

    init(viewModel: SHSquadViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refreshUI()
    }

    // MARK: - UI Setup
    
    private func setup() {
        view.backgroundColor = .brandPrimary
        backgroundImageView.image = viewModel.randomBackground
        backgroundLabel.text = UIConstants.backgroundTitle
        backgroundLabel.font = UIConstants.backgroundFont
        backgroundLabel.textColor = UIColor.brandWhite
        refreshControl.tintColor = UIColor.brandWhite
        refreshControl.addTarget(self, action: #selector(SHHomeViewController.onPullToRefreshControl), for: .valueChanged)
        setTitleView(with: UIImage(named: "marvel"))
    }
    
    // MARK: - UI / Content update
    
    private func updateHeader(forYOffset offset: CGFloat, in width: CGFloat) {
       
    }
    
    private func refreshUI() {
        
    }
 
    // MARK: - Update
    
    func updateUI(isActive active: Bool) {
        
        
    }
   
    // MARK: - Actions
    
    @objc func onPullToRefreshControl() {
        viewModel.reload()
    }
}
