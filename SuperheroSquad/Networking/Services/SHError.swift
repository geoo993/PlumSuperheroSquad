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
    case failed(String)
    case noConnection
    case authenticationError
    case dataTaskFailed
    case urlMissing
    case noData
    case encodingFailed
    case decodingError
    case outdatedRequest
    case badResponse(code: Int)
   
    var localizedDescription: String {
        switch self {
        case .unknown: return "Unknown"
        case .failed(let error): return "Error: \(error)"
        case .authenticationError: return "You need to be authenticated"
        case .noConnection: return "Please connect to the internet"
        case .dataTaskFailed: return "We encountered an issues during data task"
        case .urlMissing: return "We encounted an error using url"
        case .noData: return "Response returned with no data to decode"
        case .encodingFailed: return "Encountered error with parameters"
        case .decodingError: return "Failed to decode data"
        case .outdatedRequest: return "The url you requested is outdated"
        case .badResponse(let code): return "We had a bad network response with code \(code)"
        }
    }
}
