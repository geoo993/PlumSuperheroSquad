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

final class SHSquadDetailViewController: UIViewController {

    // MARK: - UIConstants

    enum UIConstants {
        
    }

    // MARK: - IBOutlet properties

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private let viewModel: SHSquadDetailViewModel
    private var squadDetailCollectionViewManager: SHSquadDetailCollectionViewManager?
    
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refreshUI()

    }

    // MARK: - UI Setup

    private func setup() {
        view.backgroundColor = SHHomeViewController.UIConstants.background
        view.clipsToBounds = true
        squadDetailCollectionViewManager = SHSquadDetailCollectionViewManager(viewModel: viewModel, collectionView: collectionView)
        squadDetailCollectionViewManager?.delegate = self
        viewModel.delegate = self
    }

    // MARK: - Update

    func refreshUI() {
        viewModel.reload()
        
    }
    
    // MARK: - Update
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: -

extension SHSquadDetailViewController: SHSquadDetailViewModelDelegate {
    
    // MARK: - SHSquadDetailViewModelDelegate

    func didGet(comics : [SHComic]) {
        collectionView.reloadData()
    }
    
    func didLoad(isLoading: Bool) {
        
    }
    
    func didLoadNextPage(isLoading: Bool) {
        
    }
    
    func didGet(error: SHError) {
        
    }

}

// MARK: -

extension SHSquadDetailViewController: SHSquadDetailCollectionViewManagerDelegate {
    
    // MARK: - SHSquadDetailCollectionViewManagerDelegate
    
    func manager(_ collectionViewManager: SHSquadDetailCollectionViewManager, didFireHeroFromSquad hero: SHCharacter) {
        
    }
    
    func manager(_ collectionViewManager: SHSquadDetailCollectionViewManager, didSelectComic comic: SHComic) {
        
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
