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

protocol SHSquadDetailViewModelDelegate: class {
    
    // MARK: - SHSquadDetailViewModelDelegate
    
    func didGet(comics : [SHComic])
    func didLoad(isLoading: Bool)
    func didLoadNextPage(isLoading: Bool)
    func didGet(error: SHError)
}


final class SHSquadDetailViewModel: NSObject {
    
    // MARK: - Constants
    
    enum Constants {
        static let comicslimit: Int = 25
    }
    
    enum SquadStatus {
        
        // MARK: - SquadStatus Cases
        case free
        case hired
        
        // MARK: - SquadStatus Properties
        
        var value: String {
            switch self {
            case .free: return "squad_detail__free_character".localized
            case .hired: return "squad_detail__hired_character".localized
            }
        }
    }
    
    // MARK: - Properties
    
    weak var delegate: SHSquadDetailViewModelDelegate?
    fileprivate let dataProvider = SHMarvelAPIProvider()
    let character: SHCharacter
    let status: SquadStatus
    private (set)var comics = [SHComic]()
    private (set)var pagination: SHPagination?
    private var isLoading: Bool = false
    private (set)var isLoadingNextPage: Bool = false
    
    // MARK: - Internal functions
    
    init(character: SHCharacter, status: SquadStatus = .free) {
        self.character = character
        self.status = status
        super.init()
    }
    
    func reload() {
        fetchComics()
    }
    
    // MARK: - Private functions
    
    private func fetchComics() {
        dataProvider.fetchComics(character: character) { [weak self] (result) in
            switch result {
            case .value(let data):
                self?.isLoading = false
                self?.delegate?.didLoad(isLoading: false)
                self?.updateData(with: data.comics, and: data.pagination)
            case .error(let error):
                self?.isLoading = false
                self?.delegate?.didLoad(isLoading: false)
                self?.delegate?.didGet(error: error)
            }
        }
    }
    
    private func fetchNextComics() {
        
        guard isLoadingNextPage == false, let pagination = pagination, pagination.isNextListAvailable else {
            return
        }
         
        isLoadingNextPage = true
        delegate?.didLoadNextPage(isLoading: true)
        
        let limit = Constants.comicslimit
        let offset = pagination.offset + Constants.comicslimit
        dataProvider.fetchComics(character: character, limit: limit, offset: offset) { [weak self] (result) in
            switch result {
            case .value(let data):
                self?.isLoadingNextPage = false
                self?.delegate?.didLoadNextPage(isLoading: false)
                self?.updateData(with: data.comics, and: data.pagination, isNextPage: true)
            case .error(let error):
                self?.isLoadingNextPage = false
                self?.delegate?.didLoadNextPage(isLoading: false)
                self?.delegate?.didGet(error: error)
            }
        }
    }
    
    private func updateData(with comics: [SHComic], and pagination: SHPagination, isNextPage: Bool = false) {
         self.pagination = pagination
         let previousComics = self.comics
         self.comics = isNextPage ? previousComics + comics : comics
         self.delegate?.didGet(comics: comics)
        
        print(pagination)
     }
    
}
