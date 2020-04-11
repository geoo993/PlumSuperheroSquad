//
//  UIFont+Ext.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

public enum SHFontStyle {
    
    // MARK: - Cases (fixed font sizes)
    
    case main

    // MARK: - Cases (dynamic font sizes)
    
    case title1
    case title3
    case headline
    case body
    case callout
    case subhead
    case marvel(CGFloat)

    // MARK: - Public helpers
    
    public var font: UIFont {
        return font(scalable: true)
    }
    
    public func font(scalable: Bool) -> UIFont {
        switch self {
        case .main: return UIFont(name: "AvenirNext-DemiBold", size: 22) ?? UIFont.boldSystemFont(ofSize: 22)
        
        default:
            let tuple = scalableFontStyleTuple
            if #available(iOS 11.0, *), scalable {
                let fontMetrics = UIFontMetrics(forTextStyle: tuple.textStyle)
                return fontMetrics.scaledFont(for: tuple.font)
            } else {
                return tuple.font
            }
        }
    }

    // MARK: - Private helper
    
    private var scalableFontStyleTuple: (textStyle: UIFont.TextStyle, font: UIFont) {
        switch self {
        case .title1: return (UIFont.TextStyle.title1, UIFont.boldSystemFont(ofSize: 34))
        case .title3: return (UIFont.TextStyle.title2, UIFont.boldSystemFont(ofSize: 20))
        case .headline: return (UIFont.TextStyle.headline, UIFont.boldSystemFont(ofSize: 17))
        case .body: return (UIFont.TextStyle.body, UIFont.systemFont(ofSize: 17))
        case .callout: return (UIFont.TextStyle.callout, UIFont.systemFont(ofSize: 15))
        case .subhead: return (UIFont.TextStyle.subheadline, UIFont.boldSystemFont(ofSize: 13))
        case .marvel(let size): return (UIFont.TextStyle.headline, marvelFont(size))
        default: return (UIFont.TextStyle.title1, UIFont.systemFont(ofSize: 17))
        }
    }
}

// MARK: - Custom Fonts

extension SHFontStyle {
    
    fileprivate func marvelFont(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Marvel-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
