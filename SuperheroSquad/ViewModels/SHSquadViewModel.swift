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
    fileprivate let dataProvider = SHMarvelAPIProvider()
 
    // MARK: - Internal functions
    
    override init() {
        super.init()
    }
    
    func reload() {
        fetchHeroes()
    }
    
    // MARK: - Private functions

    private func fetchHeroes() {
        
        dataProvider.fetchCharacters { (result) in
            switch result {
            case .value(let characters):
                characters.forEach({ char in
                    print()
                    print(char.id)
                    print(char.name)
                    print(char.description)
                    print(char.thumbnail.url.absoluteString)
                })
                print(characters.count)
                
            case .error(let err): break
            }
        }
    }
    
    private func fetchCharacter(id: Int) {
        dataProvider.fetchCharacter(with: id) { (result) in
            switch result {
            case .value(let characters):
                let character = characters.first!
                print()
                print(character.id)
                print(character.name)
                print(character.description)
                print(character.thumbnail.url.absoluteString)
            case .error(let err): break
            }
        }
        
    }
   
    private func fetchComics() {
        dataProvider.fetchComics { (result) in
            switch result {
            case .value(let comics):
                comics.forEach({ com in
                    print()
                    print(com.id)
                    print(com.title)
                    print(com.thumbnail.url.absoluteString)
                })
                print(comics.count)
                
            case .error(let err): break
            }
        }
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
