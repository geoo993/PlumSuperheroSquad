//
//  SHHTTPTask.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 05/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

typealias SHHTTPHeaders = [String:String]

enum SHHTTPTask {
    case request
    case requestParameters(body: SHParameters?, url: SHParameters?)
    case requestParametersAndHeaders(body: SHParameters?, url: SHParameters?, header: SHHTTPHeaders?)
}
