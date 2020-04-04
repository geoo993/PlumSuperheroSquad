//
//  SHSquadViewModel.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

final class SHSquadViewModel: NSObject {
    
    // MARK: - Constants
    
    enum Constants {
        static let backgroundImages = ["captain-marvel", "iron-man"]
    }
    
    
    // MARK: - Properties

 
    // MARK: - Internal functions
    
    override init() {
        super.init()
    }
    
    func reload() {
        fetchHeroes()
    }
    
    // MARK: - Private functions

    private func fetchHeroes() {
        
       
    }
    
}

// MARK: -

extension SHSquadViewModel {
    
    var randomBackground: UIImage? {
        let index = Int.random(min: 0, max: Constants.backgroundImages.count - 1)
        guard let randomImage = Constants.backgroundImages[safe: index] else { return nil }
        return UIImage(named: randomImage)
    }
}
