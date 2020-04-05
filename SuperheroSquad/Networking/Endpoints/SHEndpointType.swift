//
//  SHEndpointType.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 05/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//
import Foundation

protocol SHEndpointType {
    var baseURL: URL? { get }
    var path: String { get }
    var method: SHHTTPMethod { get }
    var task: SHHTTPTask { get }
    var headers: SHHTTPHeaders? { get }
    var timeoutInterval: TimeInterval { get }
}
