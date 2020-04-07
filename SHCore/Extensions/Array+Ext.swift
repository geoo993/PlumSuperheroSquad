//
//  Array+Ext.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

extension Array {
    
    /// Safely index array elements
    public subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
