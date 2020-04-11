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
    
    // https://stackoverflow.com/questions/34550630/iterate-over-collection-two-at-a-time-in-swift
    public func tuple(_ transform: (Element, Element?) -> (Element, Element?) = { ($0, $1) }) -> [(Element, Element?)] {
        return stride(from: 0, to: count, by: 2).map {
            transform(self[$0], $0 < count-1 ? self[safe: $0.advanced(by: 1)] : nil)
        }
    }
}
