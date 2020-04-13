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
import CoreData

final class SHHeroesViewModel: NSObject {
    
    // MARK: - Constants
    
    enum Constants {
        static let backgroundImages = ["captain-marvel", "iron-man", "deadpool", "thanos", "hulk"]
        static let charactersLimit: Int = 50
    }
    
    // MARK: - Properties
    weak var delegate: SHViewModelDelegate?
    
    private var fullCharacters = [SHCharacter]()
    private (set)var characters = [SHCharacter]()
    private (set)var squad = [SHCharacterModel]()
    
    let notificationFeedback = UINotificationFeedbackGenerator()
    var pagination: SHPagination?
    var isLoading: Bool = false
    var isLoadingNextPage: Bool = false
 
    // MARK: Helpers
    
    func reload(type: SHPageReloadType = .firstPage) {
        switch type {
        case .firstPage:
            fetchPage()
        case .nextPage:
            fetchNextPage()
        }
    }
    
    
    func reloadSquad() {
        updateStatus()
       
    }
    
}

extension SHHeroesViewModel: SHPageModel {

    // MARK: - SHMarvelAPIProvider

    func fetchPage() {
        
        // 1
         guard isLoading == false else {
           return
         }
         
         // 2
        isLoading = true
        delegate?.didLoad(isLoading: true)
        
        SHMarvelAPIProvider.shared.fetchCharacters { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .value(let data):
                self.isLoading = false
                self.delegate?.didLoad(isLoading: false)
                self.notificationFeedback.notificationOccurred(.success)
                self.update(marvelData: data.characters, and: data.pagination)
            case .error(let error):
                self.isLoading = false
                self.delegate?.didLoad(isLoading: false)
                self.notificationFeedback.notificationOccurred(.error)
                self.delegate?.didGet(error: error)
            }
        }
    }
    
    func fetchNextPage() {
        
        // 1
         guard isLoadingNextPage == false, let pagination = pagination, pagination.isNextListAvailable else {
           return
         }
         
        // 2
        isLoadingNextPage = true
        delegate?.didLoadNextPage(isLoading: true)
        
        SHMarvelAPIProvider.shared.fetchCharacters(offset: pagination.nextOffset) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .value(let data):
                self.isLoadingNextPage = false
                self.delegate?.didLoadNextPage(isLoading: false)
                self.notificationFeedback.notificationOccurred(.success)
                self.update(marvelData: data.characters, and: data.pagination, isNextPage: true)
            case .error(let error):
                self.isLoadingNextPage = false
                self.delegate?.didLoadNextPage(isLoading: false)
                self.notificationFeedback.notificationOccurred(.error)
                self.delegate?.didGet(error: error)
            }
        }
    }
  
    func update(marvelData: [SHCharacter], and pagination: SHPagination, isNextPage: Bool = false) {
        self.pagination = pagination
        let previousCharacters = self.fullCharacters
        let fullList = isNextPage ? previousCharacters + marvelData : marvelData
        self.fullCharacters = fullList
        self.characters = fullList.ignoreNotAvailableImages
        self.delegate?.didGet(characters)
    }
    
    // MARK: Core Data
    
    func updateStatus()  {
        
        SHMarvelAPIProvider.shared.fetchSquad { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .value(let data):
                self.squad = data
                self.delegate?.didGet(data)
            case .error(let error):
                self.delegate?.didGet(error: error)
            }
        }
    }
     
}

// MARK: -

extension SHHeroesViewModel {
    
    var randomBackground: UIImage? {
        let index = Int.random(in: 0..<Constants.backgroundImages.count)
        guard let randomImage = Constants.backgroundImages[safe: index] else { return nil }
        return UIImage(named: randomImage)
    }
}
