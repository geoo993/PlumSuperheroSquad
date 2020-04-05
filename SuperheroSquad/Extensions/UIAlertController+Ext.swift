//
//  UIAlertController+Ext.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

struct SHAlertAction {

    typealias ActionHandler = (() -> Void)

    // MARK: - Properties
    
    let title: String
    let style: UIAlertAction.Style
    let handler: ActionHandler?

    // MARK: - Initializer

    init(title: String, style: UIAlertAction.Style = .default, handler: ActionHandler? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

// MARK: -

extension UIAlertController {

    // MARK: - Convenience initializer

    convenience init(title: String?, message: String?, actions: [SHAlertAction], style: UIAlertController.Style = .alert) {
        self.init(title: title, message: message, preferredStyle: style)

        actions.map { (action) -> UIAlertAction in

            return UIAlertAction(title: action.title, style: action.style, handler: { (_) in
                action.handler?()
            })

        }.forEach { (action) in
            addAction(action)
        }
    }
}

