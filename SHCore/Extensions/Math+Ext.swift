//
//  Math+Ext.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

extension Int {

    /// Returns a random integer between min and max
    public static func random(min: Int, max: Int) -> Int {
        guard min < max else { return min }
        return Int(arc4random_uniform(UInt32(1 + max - min))) + min
    }
}
