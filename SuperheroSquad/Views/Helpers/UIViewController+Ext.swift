//
//  UIViewController+Ext.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import SHCore
import TransitionAnimation

extension UIViewController {
    
    func present(viewController: UIViewController, from cell: CardCollectionViewCell, animated flag: Bool, completion: (() -> Void)? = nil) {
        
        present(viewController, animated: true, completion: { [unowned cell] in
            // Unfreeze
            cell.unfreezeAnimations()
        })
    }
    
    public func setTitleView(with image: UIImage?) {
        var titleView: UIImageView? {
            guard let image = image else { return nil }
            let imageView = UIImageView(image: image)
            let frame: CGRect
            if let navigationController = self.navigationController {
                let bannerWidth = navigationController.navigationBar.frame.size.width
                let bannerHeight = navigationController.navigationBar.frame.size.height
                let bannerX = bannerWidth / 2 - image.size.width / 2
                let bannerY = bannerHeight / 2 - image.size.height / 2
                frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
            } else {
                let defaultSize = CGSize(width: 129, height: 63)
                let bannerX = defaultSize.width / 2 - image.size.width / 2
                let bannerY = defaultSize.height / 2 - image.size.height / 2
                frame = CGRect(x: bannerX, y: bannerY, width: defaultSize.width, height: defaultSize.height)
            }
            imageView.frame = frame
            imageView.contentMode = .scaleAspectFit
            
            return imageView
        }
        self.navigationItem.titleView = titleView
    }
    
    
    func presentAlert(title: String, message: String, actions: [SHAlertAction]) {
       let alert: UIAlertController = {
           let actions = [
            SHAlertAction(title: "home_alert__ok_btn".localized, style: .default)
           ]
           return UIAlertController(title: title, message: message, actions: actions)
       }()
       present(alert, animated: true, completion: nil)
   }

}
