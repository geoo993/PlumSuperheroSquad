//
//  UIScrollView+Ext.swift
//  SHCore
//
//  Created by GEORGE QUENTIN on 06/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

public extension UIScrollView {
    
    public func fixContentInsetAdjustmentBehavior() {
        self.contentInsetAdjustmentBehavior = .never
    }
}
