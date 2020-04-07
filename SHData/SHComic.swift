//
//  SHComic.swift
//  SHData
//
//  Created by GEORGE QUENTIN on 06/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

public struct SHComic {
    public let id: Int
    public let title: String
    public let thumbnail: SHImageResource
}

extension SHComic: Decodable {
    
    enum ComicCodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case thumbnail = "thumbnail"
    }
    
    public init(from decoder: Decoder) throws {
        let comicContainer = try decoder.container(keyedBy: ComicCodingKeys.self)
        self.id = try comicContainer.decode(Int.self, forKey: .id)
        self.title = try comicContainer.decode(String.self, forKey: .title)
        self.thumbnail = try comicContainer.decode(SHImageResource.self, forKey: .thumbnail)
    }
}
