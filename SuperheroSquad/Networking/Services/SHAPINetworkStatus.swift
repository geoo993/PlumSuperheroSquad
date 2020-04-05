//
//  SHAPINetworkStatus.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 05/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

// MARK: - SHNetworkResult

enum SHNetworkResult<T> {
    
    case value(T)
    case error(SHError)
}

// MARK: - SHAPINetworkStatus

enum SHAPINetworkStatus {
    
    case online
    case offline
}
