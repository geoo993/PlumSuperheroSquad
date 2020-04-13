//
//  SHSquadStatus+Ext.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 12/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import SHData

// MARK: -

extension SHSquadStatus {
    
    // MARK: - Status Toggle
    
    var value: String {
        switch self {
        case .free: return "squad_detail__free_character".localized
        case .hired: return "squad_detail__hired_character".localized
        }
    }

}
