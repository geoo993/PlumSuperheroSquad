//
//  SHSquadDetailViewModel.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import SHAPIKit
import SHData
import SHCore
import UIKit
import CoreData

final class SHSquadDetailViewModel: NSObject {
    
    // MARK: - Properties
    
    weak var delegate: SHViewModelDelegate?
    private var ignoredComics = [SHComic]()
    private var fullComics = [SHComic]()
    
    let character: SHCharacter
    private (set)var status: SHSquadStatus = .free
    private (set)var comics = [SHComic]()
    
    let notificationFeedback = UINotificationFeedbackGenerator()
    var pagination: SHPagination?
    var isLoading: Bool = false
    var isLoadingNextPage: Bool = false
    
    // MARK: - Internal functions
    
    init(character: SHCharacter) {
        self.character = character
        super.init()
    }
    
    // MARK: Helpers
    
    func reload(type: SHPageReloadType = .firstPage) {
        switch type {
        case .firstPage:
            fetchStatus()
            fetchPage()
        case .nextPage:
            fetchNextPage()
        }
    }
    
}

extension SHSquadDetailViewModel: SHPageModel {
    
    // MARK: - Private functions
    
    func fetchPage() {
        SHMarvelAPIProvider.shared.fetchComics(characterId: character.id) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .value(let data):
                self.isLoading = false
                self.delegate?.didLoad(isLoading: false)
                self.notificationFeedback.notificationOccurred(.success)
                self.update(marvelData: data.comics, and: data.pagination)
            case .error(let error):
                self.isLoading = false
                self.delegate?.didLoad(isLoading: false)
                self.notificationFeedback.notificationOccurred(.error)
                self.delegate?.didGet(error: error)
            }
        }
    }
    
    func fetchNextPage() {
        
        guard isLoadingNextPage == false, let pagination = pagination, pagination.isNextListAvailable else {
            return
        }
         
        isLoadingNextPage = true
        delegate?.didLoadNextPage(isLoading: true)
        
        SHMarvelAPIProvider.shared.fetchComics(characterId: character.id, offset: pagination.nextOffset) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .value(let data):
                self.isLoadingNextPage = false
                self.delegate?.didLoadNextPage(isLoading: false)
                self.notificationFeedback.notificationOccurred(.success)
                self.update(marvelData: data.comics, and: data.pagination, isNextPage: true)
            case .error(let error):
                self.isLoadingNextPage = false
                self.delegate?.didLoadNextPage(isLoading: false)
                self.notificationFeedback.notificationOccurred(.error)
                self.delegate?.didGet(error: error)
            }
        }
    }
    
    func update(marvelData: [SHComic], and pagination: SHPagination, isNextPage: Bool = false) {
        self.pagination = pagination
        let previousComics = self.fullComics
        let fullList = isNextPage ? previousComics + marvelData : marvelData
        self.fullComics = fullList
        self.comics = fullList.ignoreNotAvailableImages
        self.delegate?.didGet(comics)
    }
    
    // MARK: Core Data
    
    func fetchStatus() {
        SHMarvelAPIProvider.shared.updateStatus(with: character) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .value(let status):
                self.status = status
            case .error(let error):
                self.delegate?.didGet(error: error)
            }
        }
    }
    
    func updateStatus() {
        SHMarvelAPIProvider.shared.updateStatus(with: character, toggle: true) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .value(let status):
                self.status = status
                self.delegate?.didGet([status])
            case .error(let error):
                self.delegate?.didGet(error: error)
            }
        }
    }
  
}

extension SHSquadDetailViewModel {
    
    var otherComics: Int {
        guard let total = pagination?.total else { return 0}
        return max(total - comics.count, 0)
    }
    
}
