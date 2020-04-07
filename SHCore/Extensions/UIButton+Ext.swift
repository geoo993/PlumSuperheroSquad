//
//  UIButton+Ext.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

private var ButtonLoadingAssociatedObjectHandle: UInt8 = 0

public extension UIButton {

    private var currentURL: URL? {
        get {
            return objc_getAssociatedObject(self, &ButtonLoadingAssociatedObjectHandle) as? URL
        }
        set {
            objc_setAssociatedObject(self, &ButtonLoadingAssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func setImage(with url: URL?, placeholder: UIImage? = nil) {

        setImage(placeholder, for: .normal)
        currentURL = url
        guard let currentURL = currentURL else { return }

        // TODO: cache image here
    }
}
