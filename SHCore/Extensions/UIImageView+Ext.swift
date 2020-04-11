//
//  UIImageView+Ext.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import SDWebImage

private var ImageViewLoadingAssociatedObjectHandle: UInt8 = 0

public extension UIImageView {

    private var currentURL: URL? {
        get {
            return objc_getAssociatedObject(self, &ImageViewLoadingAssociatedObjectHandle) as? URL
        }
        set {
            objc_setAssociatedObject(self, &ImageViewLoadingAssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func setImage(with url: URL?, placeholder: UIImage? = nil, ignoreCache: Bool = false, onCompletion completion: @escaping (UIImage?) -> Void = { _ in }) {

        image = placeholder
        currentURL = url
        guard let currentURL = currentURL else { return }

        self.sd_setImage(with: currentURL, completed: nil)
       
    }
}
