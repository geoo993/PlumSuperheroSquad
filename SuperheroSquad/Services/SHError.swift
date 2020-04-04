//
//  SHError.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

public enum SHError: Error {
    case unknown
    case dataTaskError
    case badResponse(code: Int)
    case badURL
   
    var localizedDescription: String {
        switch self {
        case .unknown: return "Unknown"
        case .dataTaskError: return "Error: eccounted issues during data task"
        case .badResponse(let code): return "Error: encountered error during network response with code \(code)"
        case .badURL: return "Error: Marvel url error"
        }
    }
}
