//
//  SHHeroesViewModel.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 06/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import SHAPIKit
import SHData
import SHCore
import UIKit

protocol SHHeroesViewModelDelegate: class {
    
    // MARK: - SHCharactersViewModelDelegate
    
    func didGet(characters : [SHCharacter])
    func didLoad(isLoading: Bool)
    func didLoadNextPage(isLoading: Bool)
}

// MARK: -

final class SHHeroesViewModel: NSObject {
    
    enum ReloadType {
        case first
        case nextPage
    }
    
    // MARK: - Constants
    
    enum Constants {
        static let backgroundImages = ["captain-marvel", "iron-man"]
        static let charactersLimit: Int = 50
    }
    
    // MARK: - Properties
    
    weak var delegate: SHHeroesViewModelDelegate?
    private let dataProvider = SHMarvelAPIProvider()
    private (set)var characters = [SHCharacter]()
    private (set)var pagination: SHPagination?
    private var isLoading: Bool = false
    private (set)var isLoadingNextPage: Bool = false
 
    // MARK: - Internal functions
    
    override init() {
        super.init()
    }
    
    func reload(type: ReloadType = .first) {
        switch type {
        case .first:
            fetchHeroes()
        case .nextPage:
            fetchNextHeroes()
        }
    }
    
    // MARK: - Private functions

    private func fetchHeroes() {
        
        // 1
         guard isLoading == false else {
           return
         }
         
         // 2
        isLoading = true
        delegate?.didLoad(isLoading: true)
        
        dataProvider.fetchCharacters(limit: Constants.charactersLimit) { [weak self] (result) in
            switch result {
            case .value(let data):
                self?.isLoading = false
                self?.delegate?.didLoad(isLoading: false)
                self?.updateData(with: data.characters, and: data.pagination)
            case .error(let err):
                self?.isLoading = false
                self?.delegate?.didLoad(isLoading: false)
            }
        }
    }
    
    private func fetchNextHeroes() {
        
        // 1
         guard isLoadingNextPage == false, let pagination = pagination, pagination.isNextListAvailable else {
           return
         }
         
        // 2
        isLoadingNextPage = true
        delegate?.didLoadNextPage(isLoading: true)
        
        let limit = Constants.charactersLimit
        let offset = pagination.offset + Constants.charactersLimit
        dataProvider.fetchCharacters(limit: limit, offset: offset) { [weak self] (result) in
            switch result {
            case .value(let data):
                self?.isLoadingNextPage = false
                self?.delegate?.didLoadNextPage(isLoading: false)
                self?.updateData(with: data.characters, and: data.pagination, isNextPage: true)
            case .error(let err):
                self?.isLoadingNextPage = false
                self?.delegate?.didLoadNextPage(isLoading: false)
            }
        }
    }
    
    private func fetchCharacter(id: Int) {
        dataProvider.fetchCharacter(with: id) { (result) in
            switch result {
            case .value(let character):
                break
            case .error(let err): break
            }
        }
        
    }
    
    private func updateData(with characters: [SHCharacter], and pagination: SHPagination, isNextPage: Bool = false) {
        self.pagination = pagination
        let previousCharacters = self.characters
        self.characters = isNextPage ? previousCharacters + characters : characters
        self.delegate?.didGet(characters: characters)
    }
   
}

// MARK: -

extension SHHeroesViewModel {
    
    var randomBackground: UIImage? {
        let index = Int.random(min: 0, max: Constants.backgroundImages.count - 1)
        guard let randomImage = Constants.backgroundImages[safe: index] else { return nil }
        return UIImage(named: randomImage)
    }
}
