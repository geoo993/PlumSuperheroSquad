//
//  SHComicDetailViewController.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 11/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import SHCore
import SHData
import SHAPIKit
import UIKit
import TransitionAnimation

final class SHComicDetailViewController: UIViewController {

    // MARK: - UIConstants

    enum UIConstants {
        static let background: UIColor = .brandPrimary
    }

    // MARK: - IBOutlet properties

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    
    private let comic: SHComic
    
    // MARK: - Initializers
    
    init(comic: SHComic) {
        self.comic = comic
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

    // MARK: - UI Setup

    private func setup() {
        view.backgroundColor = UIConstants.background
        view.clipsToBounds = true
        closeButton.isHidden = false
        closeButton.tintColor = UIColor.brandDeluge
        contentScrollView.contentInsetAdjustmentBehavior = .never
        imageView.setImage(with: comic.thumbnail.url)
    }
    
    // MARK: - Dismiss
    
    @IBAction func dismiss() {
        closeButton.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
}

extension SHComicDetailViewController: CardDetailViewController {
    
    var scrollView: UIScrollView {
        return contentScrollView
    }
    
    var cardContentView: UIView {
        return containerView
    }

}
