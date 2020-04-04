//
//  SHAPIClient.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

enum MarvelEndpoints {
    case all
    case hero(String)
}

protocol SHAPIClientProtocol {
    
    func fetch(heroes url: URL, networkRequest: @escaping ( _ data: Data?, _ error: SHError?) -> Void)
    func request(hero: String, completion: @escaping ((SHNetworkResult<SHCharacter>) -> Void))
}

//MAR: - APIClient

final class SHAPIClient: NSObject {
    
    // MARK: - Constants
    
    enum Constants {
        
    }
    
    // MARK: - Poperties
    
    static let shared = SHAPIClient()
    
    //private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //private static let storage = UserDefaults.standard
    private let session: SHURLSessionProtocol
    public init(session: SHURLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
}

// MARK: -

extension SHAPIClient: SHAPIClientProtocol {

    // MARK: - Requests
    
    func fetch(heroes url: URL, networkRequest: @escaping ( _ data: Data?, _ error: SHError?) -> Void) {
        
    }
    
    func request(hero: String, completion: @escaping ((SHNetworkResult<SHCharacter>) -> Void)) {
        
    }
}
