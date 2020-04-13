//
//  SHMarvelAPIProvider.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 05/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import CoreData
import SHData

// MARK: - SHNetworkResult

public enum SHNetworkResult<T> {
    
    case value(T)
    case error(SHError)
}

// MARK: - SHMarvelAPIProvider

public final class SHMarvelAPIProvider {

    // MARK: - Properties
    
    public typealias SHCharactersResult = (characters: [SHCharacter], pagination: SHPagination)
    public typealias SHComicsResult = (comics: [SHComic], pagination: SHPagination)
    private let marvel = SHAPIRequest<SHMarvelAPI>()
    
    // MARK: - Initializer

    static public let shared = SHMarvelAPIProvider()
    
    private init() {}
    
    // MARK: - Helper functions
    
    public func fetchCharacters(offset: Int = 0, completion: @escaping ((SHNetworkResult<SHCharactersResult>) -> Void) ) {
        let complete: ((SHNetworkResult<SHCharactersResult>) -> Void)  = { result in DispatchQueue.main.async { completion(result) } }
        marvel.request(with: .characters(offset: offset)) { (data, error) in
            if let error = error {
                complete(SHNetworkResult.error(error))
            } else {
                guard let responseData = data else {
                    complete(SHNetworkResult.error(SHError.noData))
                    return
                }
                do {
                    guard let newData = try self.data(with: responseData) else {
                        complete(SHNetworkResult.error(SHError.decodingError))
                        return
                    }
                    let pagination = try JSONDecoder().decode(SHPagination.self, from: newData.root)
                    let characters = try JSONDecoder().decode([SHCharacter].self, from: newData.results)
                    complete(SHNetworkResult.value((characters, pagination)))
                } catch _ {
                    complete(SHNetworkResult.error(SHError.decodingError))
                }
            }
        }
    }
    
    public func fetchComics(characterId: Int, offset: Int = 0, completion: @escaping ((SHNetworkResult<SHComicsResult>) -> Void) ) {
        let complete: ((SHNetworkResult<SHComicsResult>) -> Void)  = { result in DispatchQueue.main.async { completion(result) } }
        marvel.request(with: .comics(characterId: characterId, offset: offset)) { (data, error) in
            if let error = error {
                complete(SHNetworkResult.error(error))
            } else {
                guard let responseData = data else {
                    complete(SHNetworkResult.error(SHError.noData))
                    return
                }
                do {
                    guard
                        let newData = try self.data(with: responseData) else {
                        complete(SHNetworkResult.error(SHError.decodingError))
                        return
                    }
                    let pagination = try JSONDecoder().decode(SHPagination.self, from: newData.root)
                    let comics = try JSONDecoder().decode([SHComic].self, from: newData.results)
                    complete(SHNetworkResult.value((comics, pagination)))
                } catch _ {
                    complete(SHNetworkResult.error(SHError.decodingError))
                }
            }
        }
    }
    
    private func data(with responseData: Data) throws -> (root: Data, results: Data)? {
        let json = try JSONSerialization.jsonObject(with: responseData, options: [])
        guard
            let dict = json as? Dictionary<String, AnyObject>,
            let root = dict["data"] as? [String: Any],
            let results = root["results"] as? [[String: Any]] else {
                return nil
        }
        let rootData = try JSONSerialization.data(withJSONObject: root, options: .prettyPrinted)
        let resultData = try JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
        return (rootData, resultData)
    }
}
