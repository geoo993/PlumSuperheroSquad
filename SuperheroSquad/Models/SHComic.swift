//
//  SHComic.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 05/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

struct SHComic {
    let id: Int
    let title: String
    let thumbnail: SHImageResource
}

extension SHComic: Decodable {
    
    enum ComicCodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case thumbnail = "thumbnail"
    }
    
    init(from decoder: Decoder) throws {
        let comicContainer = try decoder.container(keyedBy: ComicCodingKeys.self)
        self.id = try comicContainer.decode(Int.self, forKey: .id)
        self.title = try comicContainer.decode(String.self, forKey: .title)
        self.thumbnail = try comicContainer.decode(SHImageResource.self, forKey: .thumbnail)
    }
}
