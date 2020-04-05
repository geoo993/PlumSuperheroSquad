//
//  SHParameterEncoding.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 05/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

typealias SHParameters = [String: Any]

protocol SHParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: SHParameters) throws
}
