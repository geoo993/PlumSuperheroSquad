//
//  UIImage+Ext.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

extension UIImage {
    
    func roundedCorners(with radius: CGFloat) -> UIImage? {
        
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        imageLayer.contents = cgImage
        imageLayer.masksToBounds = true
        imageLayer.cornerRadius = radius
        
        defer { UIGraphicsEndImageContext() }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageLayer.render(in: context)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return roundedImage
    }
}
