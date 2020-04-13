//
//  SHViewModelDelegate.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 11/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import SHAPIKit

protocol SHViewModelDelegate: class {
    
    // MARK: - SHViewModelDelegate
    
    func didGet(_ elements : [Any])
    func didLoad(isLoading: Bool)
    func didLoadNextPage(isLoading: Bool)
    func didGet(error: SHError)
}

