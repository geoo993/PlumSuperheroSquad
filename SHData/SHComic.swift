//
//  SHComic.swift
//  SHData
//
//  Created by GEORGE QUENTIN on 06/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

public final class SHComic {
    public let id: Int
    public let title: String
    public let thumbnail: SHImageResource
    init(id: Int, title: String, thumbnail: SHImageResource) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
    }
}

// MARK: - Decodable

extension SHComic: Decodable {
    
    enum ComicCodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case thumbnail = "thumbnail"
    }
    
    public convenience init(from decoder: Decoder) throws {
        let comicContainer = try decoder.container(keyedBy: ComicCodingKeys.self)
        let id = try comicContainer.decode(Int.self, forKey: .id)
        let title = try comicContainer.decode(String.self, forKey: .title)
        let thumbnail = try comicContainer.decode(SHImageResource.self, forKey: .thumbnail)
        self.init(id: id, title: title, thumbnail: thumbnail)
    }
}

// MARK: - Array

extension Array where Element == SHComic {
    
    public var ignoreNotAvailableImages: [SHComic] {
        return self.filter({ $0.thumbnail.lastPathComponent != "image_not_available" && $0.thumbnail.lastPathComponent != "4c002e0305708" })
    }
}
