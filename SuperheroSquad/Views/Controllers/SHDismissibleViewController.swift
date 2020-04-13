//
//  SHDismissibleViewController.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 13/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

protocol SHViewControllerDismissible {
    var didDismiss : (() -> Void)? { get set }
}

class SHDismissibleViewController: UIViewController, SHViewControllerDismissible {
    var didDismiss: (() -> Void)?
}
