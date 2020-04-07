//
//  SHHomeViewController.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import SHCore
import SHData
import UIKit

final class SHHomeViewController: UIViewController {


    // MARK: - UIConstants
    
    enum UIConstants {
        static let backgroundTitle = "home__background_title".localized
        static let backgroundFont = SHFontStyle.marvel(30).font
        static let nextPageLoadingViewHeight: CGFloat = 80.0
    }
    
    // MARK: - IBOutlet properties
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var backgroundLabel: UILabel!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var heroesCollectionView: UITableView!
    @IBOutlet private weak var heroesTableView: UITableView!
    
    // MARK: - Properties
    
    private let squadViewModel: SHSquadViewModel
    private let heroesViewModel: SHHeroesViewModel
    private var collectionViewManager: SHSquadCollectionViewManager?
    private var tableViewManager: SHHeroesTableViewManager
    private let refreshControl = UIRefreshControl()

    // MARK: - Initializers

    init(squadViewModel: SHSquadViewModel, heroesViewModel: SHHeroesViewModel) {
        self.squadViewModel = squadViewModel
        self.heroesViewModel = heroesViewModel
        self.tableViewManager = SHHeroesTableViewManager(viewModel: heroesViewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refreshUI()
    }

    // MARK: - UI Setup
    
    private func setup() {
        view.backgroundColor = .brandPrimary
        backgroundImageView.image = heroesViewModel.randomBackground
        backgroundLabel.text = UIConstants.backgroundTitle
        backgroundLabel.font = UIConstants.backgroundFont
        backgroundLabel.textColor = UIColor.brandWhite
        refreshControl.tintColor = UIColor.brandWhite
        refreshControl.addTarget(self, action: #selector(onPullToRefreshControl(sender:)), for: .valueChanged)
        setTitleView(with: UIImage(named: "marvel"))
        
        heroesViewModel.delegate = self
        heroesTableView.addSubview(refreshControl)
        tableViewManager.tableView = heroesTableView
        tableViewManager.delegate = self
    }
    
    // MARK: - UI / Content update
    
    private func updateHeader(forYOffset offset: CGFloat, in width: CGFloat) {
       
    }
    
    private func refreshUI() {
        heroesViewModel.reload()
        
    }
 
    // MARK: - Update
    
    func updateUI(isActive active: Bool) {
        
        
    }
   
    // MARK: - Actions
    
    @objc func onPullToRefreshControl(sender: UIRefreshControl) {
        sender.beginRefreshing()
        refreshUI()
    }
    
    func presentAlert(title: String, message: String) {
        let alert: UIAlertController = {
            let actions = [
                SHAlertAction(title: "alert__try_again_btn".localized, style: .default),
                SHAlertAction(title: "alert__cancel_btn".localized, style: .cancel)
            ]
            return UIAlertController(title: title, message: message, actions: actions)
        }()
        present(alert, animated: true, completion: nil)
    }

}

// MARK: -

extension SHHomeViewController: SHHeroesViewModelDelegate {
    
    // MARK: - SHHeroesViewModelDelegate
    
    func didGet(characters: [SHCharacter]) {
        
        heroesTableView.reloadData()
    }
    
    func didLoad(isLoading: Bool) {
        if !isLoading {
            refreshControl.endRefreshing()
        }
    }
    
    func didLoadNextPage(isLoading: Bool) {
        heroesTableView.tableFooterView = {
            guard isLoading else { return UIView() }
            let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: heroesTableView.bounds.width, height: UIConstants.nextPageLoadingViewHeight)
            activityIndicator.startAnimating()
            return activityIndicator
        }()
        
    }
   
}

// MARK: -

extension SHHomeViewController: SHHeroesTableViewManagerDelegate {
    
    // MARK: - SHHeroesTableViewManagerDelegate
    
    func didSelectHero(_ tableViewManager: SHHeroesTableViewManager, selectedHero hero: SHCharacter) {
        
    }
    
}
