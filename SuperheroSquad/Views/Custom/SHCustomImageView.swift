//
//  SHCustomImageView.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

@IBDesignable
class SHCustomImageView: UIImageView {
    
    // MARK: - Border Properties
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor ?? UIColor.clear.cgColor
        }
    }
    
    @IBInspectable var isRounded: Bool = false {
        didSet {
            if isRounded {
                cornerRadius = self.frame.width / 2.0
            }
        }
    }
    
    // MARK: - Initializers
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    // MARK: - Functions
    
    private func setupView() {
        if isRounded {
            cornerRadius = self.frame.width / 2.0
        }
        clipsToBounds = isRounded
        layer.borderColor = borderColor?.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
    }
}

