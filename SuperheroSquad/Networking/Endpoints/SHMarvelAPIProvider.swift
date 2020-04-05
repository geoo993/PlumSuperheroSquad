//
//  SHMarvelAPIProvider.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 05/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

final class SHMarvelAPIProvider {

    private let marvel = SHAPIRequest<SHMarvelAPI>()
    
    // MARK: - Initializer

    public init() {}
    
    // MARK: - Helper functions
    
    func fetchCharacter(with characterId: Int, completion: @escaping ((SHNetworkResult<[SHCharacter]>) -> Void) ) {
        let complete: ((SHNetworkResult<[SHCharacter]>) -> Void)  = { result in DispatchQueue.main.async { completion(result) } }
        marvel.request(with: .character(characterId: characterId)) { (data, error) in
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
                    let characters = try JSONDecoder().decode([SHCharacter].self, from: newData)
                    complete(SHNetworkResult.value(characters))
                } catch _ {
                    complete(SHNetworkResult.error(SHError.decodingError))
                }
            }
        }
    
    }
    
    func fetchCharacters(with limit: Int = 100, offset: Int = 0, completion: @escaping ((SHNetworkResult<[SHCharacter]>) -> Void) ) {
        let complete: ((SHNetworkResult<[SHCharacter]>) -> Void)  = { result in DispatchQueue.main.async { completion(result) } }
        marvel.request(with: .characters(limit: limit, offset: offset)) { (data, error) in
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
                    let characters = try JSONDecoder().decode([SHCharacter].self, from: newData)
                    complete(SHNetworkResult.value(characters))
                } catch _ {
                    complete(SHNetworkResult.error(SHError.decodingError))
                }
            }
        }
    }
    
    func fetchComics(with limit: Int = 100, offset: Int = 0,completion: @escaping ((SHNetworkResult<[SHComic]>) -> Void) ) {
        let complete: ((SHNetworkResult<[SHComic]>) -> Void)  = { result in DispatchQueue.main.async { completion(result) } }
        marvel.request(with: .comics(limit: limit, offset: offset)) { (data, error) in
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
                    let comics = try JSONDecoder().decode([SHComic].self, from: newData)
                    complete(SHNetworkResult.value(comics))
                } catch _ {
                    complete(SHNetworkResult.error(SHError.decodingError))
                }
            }
        }
    }
    
    private func data(with responseData: Data) throws -> Data? {
        let json = try JSONSerialization.jsonObject(with: responseData, options: [])
        guard
            let dict = json as? Dictionary<String, AnyObject>,
            let results = dict["data"]?["results"] as? [[String: Any]] else {
                return nil
        }
        return  try JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
    }
}
