//
//  SHMarvelAPI.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import CryptoSwift

private enum Constants {
    static let PUBLIC_KEY = "03633e50c5a01a48febcef37fde853be"
    static let PRIVATE_KEY = "f476d29d563b604c805f704ba4196ac5342d2a9c"
    static let ts = Date().timeIntervalSince1970.description
    static let hash = "\(ts)\(PRIVATE_KEY)\(PUBLIC_KEY)".md5()
    static let CHARACTERS_LIMIT = 50
    static let COMICS_LIMIT = 25
}

enum SHMarvelAPI {
    case characters(offset: Int)
    case comics(characterId: Int, offset: Int)
    case comic(comicId: Int)
}

//MAR: - SHMarvelAPIType Extension

extension SHMarvelAPI: SHEndpointType {
    
    var baseURL: URL? {
        return URL(string: "https://gateway.marvel.com")
    }
    
    var path: String {
        switch self {
        case .characters:
            return "/v1/public/characters"
        case .comics(let characterId, _):
            return "/v1/public/characters/\(characterId)/comics"
        case .comic(let comicId):
            return "/v1/public/comics/\(comicId)"
        }
    }
    
    var method: SHHTTPMethod {
        return .get
    }
    
    var task: SHHTTPTask {
        switch self {
        case .comics(_, let offset):
            return .requestParameters(body: nil,
                                      url: ["ts":       Constants.ts,
                                            "apikey":   Constants.PUBLIC_KEY,
                                            "hash":     Constants.hash,
                                            "limit":    Constants.COMICS_LIMIT,
                                            "offset":   offset
            ])
        case .characters(let offset):
            return .requestParameters(body: nil,
                                      url: ["ts":       Constants.ts,
                                            "apikey":   Constants.PUBLIC_KEY,
                                            "hash":     Constants.hash,
                                            "limit":    Constants.CHARACTERS_LIMIT,
                                            "offset":   offset
            ])
        default:
            return .requestParameters(body: nil,
                                      url: ["ts":       Constants.ts,
                                            "apikey":   Constants.PUBLIC_KEY,
                                            "hash":     Constants.hash,
                                            "limit":    Constants.CHARACTERS_LIMIT,
                                            "offset":   "0"
            ])
        }
    }
    
    var headers: SHHTTPHeaders? {
        return nil
    }
    
    var timeoutInterval: TimeInterval {
        return 30.0
    }

}
