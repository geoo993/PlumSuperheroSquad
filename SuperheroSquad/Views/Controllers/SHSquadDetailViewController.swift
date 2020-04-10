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
    private var heroCharacter: SHCharacter

    // MARK: - Initializers

    init(hero: SHCharacter) {
        self.heroCharacter = hero
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

    }

    // MARK: - Update

    func refreshUI() {
        
        
    }
    
    // MARK: - Update
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
