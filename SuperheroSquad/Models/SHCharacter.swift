//
//  SHCharacter.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

struct SHCharacter {
    let id: Int
    let name: String
    let description: String
    let thumbnail: SHImageResource
}

extension SHCharacter: Decodable {
    
    enum CharacterCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case thumbnail = "thumbnail"
    }
    
    init(from decoder: Decoder) throws {
        let characterContainer = try decoder.container(keyedBy: CharacterCodingKeys.self)
        id = try characterContainer.decode(Int.self, forKey: .id)
        name = try characterContainer.decode(String.self, forKey: .name)
        description = try characterContainer.decode(String.self, forKey: .description)
        thumbnail = try characterContainer.decode(SHImageResource.self, forKey: .thumbnail)
    }
}
