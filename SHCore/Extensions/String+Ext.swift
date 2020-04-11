//
//  String+Ext.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    // MARK: - Localization
    
    public var localized: String {
        return localizedWithComment("")
    }

    public func localizedWithComment(_ comment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
   
    // MARK: - Sizing
    
    public func boundingBox(constrainedWith width: CGFloat, font: UIFont) -> CGRect {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox
    }

    public func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        return ceil(boundingBox(constrainedWith: width, font: font).height)
    }
    
}
