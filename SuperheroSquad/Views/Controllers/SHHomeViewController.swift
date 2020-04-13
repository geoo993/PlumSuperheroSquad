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
        static let squadTextColor = UIColor.brandWhite
        static let squadTextFont = SHFontStyle.marvel(24).font(scalable: false)
    }
    
    // MARK: - IBOutlet properties
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var squadContainer: UIView!
    @IBOutlet private weak var squadLabel: UILabel!
    @IBOutlet private weak var squadCollectionView: UICollectionView!
    @IBOutlet private weak var heroesCollectionView: UICollectionView!
    
    // MARK: - Properties
    
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
        viewModel.reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadSquad()
    }
    
    // MARK: - UI Setup
    
    private func setup() {
        
        view.backgroundColor = UIConstants.background
        backgroundImageView.image = viewModel.randomBackground
        setTitleView(with: UIImage(named: "marvel"))
        
        squadLabel.text = "home__my_squad".localized
        squadLabel.textColor = UIConstants.squadTextColor
        squadLabel.font = UIConstants.squadTextFont
        squadCollectionViewManager = SHSquadCollectionViewManager(viewModel: viewModel, collectionView: squadCollectionView)
        squadCollectionViewManager?.delegate = self
        heroesCollectionView.refreshControl = UIRefreshControl()
        heroesCollectionView.refreshControl?.tintColor = UIColor.brandWhite
        heroesCollectionView.refreshControl?.addTarget(self, action: #selector(onPullToRefreshControl(sender:)), for: .valueChanged)
        heroesCollectionViewManager = SHHeroesCollectionViewManager(viewModel: viewModel, collectionView: heroesCollectionView)
        heroesCollectionViewManager?.delegate = self
        viewModel.delegate = self
    }
    
    // MARK: - UI / Content update
 
    private func hide(squad isHidden: Bool) {
        if !isHidden {
            self.squadContainer.isHidden = false
            self.squadCollectionView.isHidden = false
        }
        UIView.animate(withDuration: 0.3, animations: { [weak self] () in
            guard let self = self else { return }
            self.squadContainer.alpha = isHidden ? 0 : 1
            self.squadCollectionView.alpha = isHidden ? 0 : 1
            self.view.layoutIfNeeded()
        }, completion: { [weak self] finished in
            guard let self = self else { return }
            self.squadContainer.isHidden = isHidden
            self.squadCollectionView.isHidden = isHidden
        })
    }
    
    // MARK: - Actions
    
    @objc func onPullToRefreshControl(sender: UIRefreshControl) {
        sender.beginRefreshing()
        viewModel.reload()
    }
    
}

// MARK: -

extension SHHomeViewController: SHViewModelDelegate {
    
    // MARK: - SHHeroesViewModelDelegate
    
    func didGet( _ elements: [Any]) {
        
        if elements is [SHCharacter] {
            heroesCollectionView.reloadData()
        }
        
        if let squad = elements as? [SHCharacterModel] {
            if squad.hasSquad {
                squadCollectionView.reloadData()
            }
            hide(squad: !squad.hasSquad)
        }
        
    }
    
    func didLoad(isLoading: Bool) {
        if !isLoading {
            heroesCollectionView.refreshControl?.endRefreshing()
            hide(squad: !viewModel.squad.hasSquad)
        }
    }
    
    func didLoadNextPage(isLoading: Bool) {
       
    }
   
    func didGet(error: SHError) {
        heroesCollectionView.refreshControl?.endRefreshing()
        switch error {
        case .noConnection, .noData, .badResponse, .outdatedRequest, .failed, .coreDataError:
            let actions = [
                SHAlertAction(title: "home_alert__ok_btn".localized, style: .default)
            ]
            presentAlert(title: "home_alert__title".localized, message: "home_alert__description".localized, actions: actions)
        default: break
        }
    }
}

// MARK: -

extension SHHomeViewController: SHHeroesCollectionViewManagerDelegate, SHSquadCollectionViewManagerDelegate {

    // MARK: - SHHeroesTableViewManagerDelegate
    
    func manager(_ collectionViewManager: SHHeroesCollectionViewManager, didSelectHero hero: SHCharacter, in cell: SHHereosCollectionViewCell) {
        
        let squadVC = SHSquadDetailViewController(viewModel: SHSquadDetailViewModel(character: hero))
        cell.settings.isEnabledBottomClose = false
        cell.settings.cardCornerRadius = SHHereosCollectionViewCell.UIConstants.cornerRadius
        cell.settings.cardVerticalExpandingStyle = .fromTop
        cell.settings.cardHorizontalEPositioningStyle = .fromCenter
        cell.settings.cardContainerPresentationBeginInsets = UIEdgeInsets.zero
        cell.settings.cardContainerPresentationInsets = UIEdgeInsets.zero
        cell.settings.cardContainerDismissInsets = UIEdgeInsets.zero
        transition = CardTransition(cell: cell, settings: cell.settings)
        squadVC.settings = cell.settings
        squadVC.transitioningDelegate = transition
        squadVC.modalPresentationStyle = .custom
        present(viewController: squadVC, from: cell)
    }
    
    // MARK: - SHSquadCollectionViewManagerDelegate
    
    func manager(_ collectionViewManager: SHSquadCollectionViewManager, didSelectHero hero: SHCharacter, in cell: SHSquadCollectionViewCell) {
        let squadVC = SHSquadDetailViewController(viewModel: SHSquadDetailViewModel(character: hero))
        transition = nil
        squadVC.transitioningDelegate = transition
        squadVC.modalPresentationStyle = .custom
        present(viewController: squadVC, from: cell, onCompletion: nil) { [weak self] () in
            self?.viewWillAppear(true)
        }
    }
}

extension SHHomeViewController: CardsViewController { }
