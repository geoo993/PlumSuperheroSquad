//
//  SHJSONParameterEncoder.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 05/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

struct JSONParameterEncoder: SHParameterEncoder {
    
    static func encode(urlRequest: inout URLRequest, with parameters: SHParameters) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw SHError.encodingFailed
        }
    }
}
