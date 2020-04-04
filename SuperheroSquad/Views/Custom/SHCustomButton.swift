//
//  SHCustomButton.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

@IBDesignable
class SHCustomButton: UIButton {
    
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
    
    //    MARK: - Gradient Properties
    
    @IBInspectable var firstColor: UIColor = UIColor.white {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.white {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var horizontalGradient: Bool = false {
        didSet {
            updateGradient()
        }
    }
    
    override public class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
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
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor?.cgColor
        self.layer.borderWidth = borderWidth
        self.updateGradient()
    }
    
    private func updateGradient() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [ firstColor.cgColor, secondColor.cgColor ]
        
        if (horizontalGradient) {
            layer.startPoint = CGPoint(x: 0.0, y: 0.5)
            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
        }
    }

}
