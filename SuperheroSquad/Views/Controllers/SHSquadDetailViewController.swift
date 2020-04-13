//
//  SHSquadDetailViewController.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 09/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import SHCore
import SHData
import SHAPIKit
import UIKit
import TransitionAnimation

final class SHSquadDetailViewController: SHDismissibleViewController {

    // MARK: - UIConstants

    enum UIConstants {
        static let background: UIColor = .brandPrimary
    }

    // MARK: - IBOutlet properties

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    private let viewModel: SHSquadDetailViewModel
    private var squadDetailCollectionViewManager: SHSquadDetailCollectionViewManager?
    private var transition: CardTransition?
    
    // MARK: - Initializers
    
    init(viewModel: SHSquadDetailViewModel) {
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

    // MARK: - UI Setup

    private func setup() {
        view.backgroundColor = UIConstants.background
        view.clipsToBounds = true
        closeButton.tintColor = UIColor.brandTertiary
        closeButton.isHidden = true
        squadDetailCollectionViewManager = SHSquadDetailCollectionViewManager(viewModel: viewModel, collectionView: collectionView)
        squadDetailCollectionViewManager?.delegate = self
        viewModel.delegate = self
    }

    // MARK: - Dismiss
    
    @IBAction func dismiss(_ sender: UIButton) {
        closeButton.isHidden = true
        didDismiss?()
    }
    
}

// MARK: -

extension SHSquadDetailViewController: SHViewModelDelegate {
    
    // MARK: - SHSquadDetailViewModelDelegate

    func didGet(_ elements : [Any]) {
        collectionView.reloadData()
        closeButton.isHidden = false
    }
    
    func didLoad(isLoading: Bool) {
        
    }
    
    func didLoadNextPage(isLoading: Bool) {
        
    }
    
    func didGet(error: SHError) {
        closeButton.isHidden = false
        switch error {
        case .noConnection, .noData, .badResponse, .outdatedRequest, .failed, .coreDataError:
            let actions = [
                SHAlertAction(title: "home_alert__try_again_btn".localized, style: .default, handler: { [weak self] () in
                    self?.viewModel.reload()
                }),
                SHAlertAction(title: "home_alert__cancel_btn".localized, style: .cancel)
            ]
            presentAlert(title: "home_alert__title".localized, message: "home_alert__description".localized, actions: actions)
        default: break
        }
    }

}

// MARK: -

extension SHSquadDetailViewController: SHSquadDetailCollectionViewManagerDelegate {
   
    // MARK: - SHSquadDetailCollectionViewManagerDelegate
    
    func manager(_ collectionViewManager: SHSquadDetailCollectionViewManager, didSelectComic comic: SHComic,
                 in cell: SHComicCollectionViewCell, at position: SHSquadDetailCollectionViewManager.SHComicPosition) {
        
        let comicDetailVC = SHComicDetailViewController(comic: comic)
        cell.settings.cardVerticalExpandingStyle = .fromTop
        cell.settings.cardHorizontalEPositioningStyle = (position == .right) ? .fromRight : .fromLeft
        cell.settings.cardContainerPresentationBeginInsets = UIEdgeInsets(top: 0, left: (position == .right) ? 0 : 15, bottom: 0, right: (position == .right) ? -15 : 0)
        let bottom = cell.frame.height - (cell.frame.width * SHComicsCollectionViewCell.UIConstants.imagesAspectRatio)
        cell.settings.cardContainerPresentationInsets = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
        cell.settings.cardContainerDismissInsets = UIEdgeInsets(top: 0, left: (position == .right) ? 0 : 15, bottom: bottom, right: (position == .right) ? -15 : 0)
        cell.settings.isEnabledBottomClose = false
        
        transition = CardTransition(cell: cell, settings: cell.settings)
        
        comicDetailVC.settings = cell.settings
        comicDetailVC.transitioningDelegate = transition
        comicDetailVC.modalPresentationStyle = .custom
        present(viewController: comicDetailVC, from: cell, onCompletion: nil, onDismiss: nil)
    }
    
}

// MARK: -

extension SHSquadDetailViewController: CardDetailViewController {
    
    // MARK: - Transition Animation
    
    var scrollView: UIScrollView {
        return collectionView
    }
    
    
    var cardContentView: UIView {
        return containerView
    }

}

extension SHSquadDetailViewController: CardsViewController { }
