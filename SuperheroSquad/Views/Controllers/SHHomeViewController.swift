//
//  SHHomeViewController.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import SHCore
import SHData
import SHAPIKit
import UIKit
import TransitionAnimation

final class SHHomeViewController: UIViewController {


    // MARK: - UIConstants
    
    enum UIConstants {
        static let background: UIColor = .brandPrimary
        static let backgroundTitle = "home__background_title".localized
        static let backgroundFont = SHFontStyle.marvel(30).font
        static let nextPageLoadingViewHeight: CGFloat = 80.0
    }
    
    // MARK: - IBOutlet properties
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var backgroundLabel: UILabel!
    @IBOutlet private weak var heroesCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private let viewModel: SHHeroesViewModel
    private var squadCollectionViewManager: SHSquadCollectionViewManager?
    private var heroesCollectionViewManager: SHHeroesCollectionViewManager?
    private var transition: CardTransition?

    // MARK: - Initializers

    init(viewModel: SHHeroesViewModel) {
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
        refreshUI()
    }
    
    // MARK: - UI Setup
    
    private func setup() {
        view.backgroundColor = UIConstants.background
        backgroundImageView.image = viewModel.randomBackground
        backgroundLabel.text = UIConstants.backgroundTitle
        backgroundLabel.font = UIConstants.backgroundFont
        backgroundLabel.textColor = UIColor.brandWhite
        setTitleView(with: UIImage(named: "marvel"))
        
        heroesCollectionView.refreshControl = UIRefreshControl()
        heroesCollectionView.refreshControl?.tintColor = UIColor.brandWhite
        heroesCollectionView.refreshControl?.addTarget(self, action: #selector(onPullToRefreshControl(sender:)), for: .valueChanged)
        heroesCollectionViewManager = SHHeroesCollectionViewManager(viewModel: viewModel, collectionView: heroesCollectionView)
        heroesCollectionViewManager?.delegate = self
        viewModel.delegate = self
    }
    
    // MARK: - UI / Content update
   
    private func refreshUI() {
        viewModel.reload()
        
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
                SHAlertAction(title: "home_alert__ok_btn".localized, style: .default)
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
        heroesCollectionView.reloadData()
        
    }
    
    func didLoad(isLoading: Bool) {
        if !isLoading {
            heroesCollectionView.refreshControl?.endRefreshing()
        }
    }
    
    func didLoadNextPage(isLoading: Bool) {
       
    }
   
    func didGet(error: SHError) {
        heroesCollectionView.refreshControl?.endRefreshing()
        switch error {
        case .noConnection, .noData, .badResponse, .outdatedRequest, .failed:
            presentAlert(title: "home_alert__title".localized, message: "home_alert__description".localized)
        default: break
        }
    }
}

// MARK: -

extension SHHomeViewController: SHHeroesCollectionViewManagerDelegate {

    
    // MARK: - SHHeroesTableViewManagerDelegate
    
    func manager(_ collectionViewManager: SHHeroesCollectionViewManager, didSelectHero hero: SHCharacter, in cell: SHHereosCollectionViewCell) {
        
        let squadVC = SHSquadDetailViewController(viewModel: SHSquadDetailViewModel(character: hero))
        squadVC.loadViewIfNeeded()
        squadVC.view.layoutIfNeeded()
        
        cell.settings.isEnabledBottomClose = false
        cell.settings.cardCornerRadius = SHHereosCollectionViewCell.UIConstants.cornerRadius
        cell.settings.cardVerticalExpandingStyle = .fromTop
        cell.settings.cardContainerInsets = UIEdgeInsets.zero
        transition = CardTransition(cell: cell, settings: cell.settings)
        
        squadVC.settings = cell.settings
        squadVC.transitioningDelegate = transition
        squadVC.modalPresentationStyle = .custom
        
        present(viewController: squadVC, from: cell, animated: true, completion: nil)
        
    }
    
}

extension SHHomeViewController: CardsViewController { }
