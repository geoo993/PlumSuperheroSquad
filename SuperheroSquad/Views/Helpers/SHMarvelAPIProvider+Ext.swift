//
//  SHMarvelAPIProvider+Ext.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 12/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import SHAPIKit
import SHData
import CoreData
import UIKit

// MARK: -

extension SHMarvelAPIProvider {

    // MARK: - Core Data stack
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func fetchSquad(completion: @escaping ((SHNetworkResult<[SHCharacterModel]>) -> Void)) {
        
        // fetch (id, name, status)
        let request: NSFetchRequest<SHCharacterModel> = SHCharacterModel.fetchRequest()
        do {
            let squad = try context.fetch(request)
            completion(SHNetworkResult.value(squad))
        } catch let error {
            completion(SHNetworkResult.error(SHError.coreDataError(error.localizedDescription)))
        }
     }
              
    func updateStatus(with character: SHCharacter, toggle: Bool = false, completion: @escaping ((SHNetworkResult<SHSquadStatus>) -> Void)) {
        
         // store (id, name, status)
         let request: NSFetchRequest<SHCharacterModel> = SHCharacterModel.fetchRequest()
         do {
             let squad = try context.fetch(request)
             let characterItem: SHCharacterModel = squad.first(where: { $0.id == character.id }) ?? SHCharacterModel(context: context)
             characterItem.id = Int32(character.id)
             characterItem.name = character.name
             characterItem.desc = character.description
             characterItem.url = character.thumbnail.url.absoluteString
             let status: SHSquadStatus = {
                if let status = characterItem.status, let currentStatus = SHSquadStatus(rawValue: status) {
                    return toggle ? currentStatus.toggle() : currentStatus
                } else {
                    return SHSquadStatus.free
                }
             }()
            characterItem.status = status.rawValue
            try context.save()
            completion(SHNetworkResult.value(status))
         } catch let error {
             completion(SHNetworkResult.error(SHError.coreDataError(error.localizedDescription)))
         }
        
     }
}

// MARK: -

extension SHSquadStatus {
    
    // MARK: - Status Toggle
   
    fileprivate func toggle() -> SHSquadStatus {
        switch self {
        case .free:
            return .hired
        case .hired:
            return .free
        }
    }
    
}
