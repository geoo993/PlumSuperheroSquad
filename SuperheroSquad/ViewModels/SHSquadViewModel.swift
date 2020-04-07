//
//  SHSquadViewModel.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import SHAPIKit
import SHData
import SHCore
import UIKit

final class SHSquadViewModel: NSObject {
    
    // MARK: - Constants
    
    enum Constants {
        static let backgroundImages = ["captain-marvel", "iron-man"]
    }
    
    // MARK: - Properties
    
    fileprivate let dataProvider = SHMarvelAPIProvider()

    // MARK: - Internal functions
    
    override init() {
        super.init()
    }
    
    func reload() {
        fetchSquad()
    }
    
    // MARK: - Private functions

    private func fetchSquad() {
     
    }
    
    private func fetchComics() {
        dataProvider.fetchComics { (result) in
            switch result {
            case .value(let comics): break
              
            case .error(let err): break
            }
        }
     }
    
}
