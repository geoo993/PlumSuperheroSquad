//
//  SHNavigationViewController.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

final class SHNavigationViewController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for:.default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
   
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
}
