//
//  SHCharacter.swift
//  SHData
//
//  Created by GEORGE QUENTIN on 06/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

public struct SHCharacter {
    public let id: Int
    public let name: String
    public let description: String
    public let thumbnail: SHImageResource
    
    public init(id: Int, name: String, description: String, thumbnail: SHImageResource) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
    }
}

// MARK: - Decodable

extension SHCharacter: Decodable {
    
    enum CharacterCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case thumbnail = "thumbnail"
    }

    public init(from decoder: Decoder) throws {
        let characterContainer = try decoder.container(keyedBy: CharacterCodingKeys.self)
        id = try characterContainer.decode(Int.self, forKey: .id)
        name = try characterContainer.decode(String.self, forKey: .name)
        description = try characterContainer.decode(String.self, forKey: .description)
        thumbnail = try characterContainer.decode(SHImageResource.self, forKey: .thumbnail)
        
    }
}

// MARK: - Array

extension Array where Element == SHCharacter {
    
    public var ignoreNotAvailableImages: [SHCharacter] {
        return self.filter({ $0.thumbnail.lastPathComponent != "image_not_available" && $0.thumbnail.lastPathComponent != "4c002e0305708" })
    }
}
