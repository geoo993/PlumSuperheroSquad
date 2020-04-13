//
//  UIColor+Ext.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

public extension UIColor {

    /**
     Style guide: Primary brand color
     */
    static var brandPrimary: UIColor {
        return UIColor(hex: 0x22252b)
    }
    
    /**
     Style guide: Secondary brand color
     */
    static var brandSecondary: UIColor {
        return UIColor(hex: 0x363b45)
    }

    /**
     Style guide: Third Main color - Deluge
     */
    static var brandTertiary: UIColor {
        return UIColor(hex: 0x827397)
    }
    
    /**
     Style guide: Main red color
     */
    static var brandRed: UIColor {
        return UIColor(red: 243, green: 11, blue: 10)
    }

    /**
    Style guide: Main white color
    */
    static var brandWhite: UIColor {
        return UIColor(red: 240, green: 240, blue: 255)
    }
    
    // MARK: - Initializers
    
    convenience private init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }

    convenience private init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

}
