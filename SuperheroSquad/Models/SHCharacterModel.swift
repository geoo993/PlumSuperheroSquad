//
//  SHCharacter.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import CoreData
import SHData

// MARK: - Core Data Model

public class SHCharacterModel: NSManagedObject {

}

extension SHCharacterModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SHCharacterModel> {
        return NSFetchRequest<SHCharacterModel>(entityName: "SHCharacterModel")
    }

    @NSManaged public var id: Int32
    @NSManaged public var desc: String?
    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var status: String?
}

extension SHCharacterModel {

    var asSquadCharacter: SHCharacter? {
        guard
            let name = name,
            let description = desc,
            let urlPath = url,
            let thumbnail = SHImageResource(from: urlPath),
            let status = status, let currentStatus = SHSquadStatus(rawValue: status), currentStatus == .hired else { return nil }
        return SHCharacter(id: Int(id), name: name, description: description, thumbnail: thumbnail)
    }
}

extension Array where Element: SHCharacterModel {
    
    var hasSquad: Bool {
        return self.compactMap({ $0.asSquadCharacter }).count > 0
    }
}
