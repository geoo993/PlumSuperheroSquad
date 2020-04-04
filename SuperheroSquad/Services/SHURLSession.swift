//
//  SHURLSession.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

// MARK: - SHNetworkResult

public enum SHNetworkResult<T> {
    case value([T])
    case error(SHError)
}

// MARK: - SHURLSessionProtocol

public protocol SHURLSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> SHURLSessionDataTaskProtocol
}

//MARK: - SHURLSessionDataTaskProtocol

public protocol SHURLSessionDataTaskProtocol {
    func resume()
}

//MAR: - URLSession extension

extension URLSession: SHURLSessionProtocol {
    
    public func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> SHURLSessionDataTaskProtocol {
        return (dataTask(with: request, completionHandler: completion) as URLSessionDataTask) as SHURLSessionDataTaskProtocol
    }
}

//MAR: - SHURLSessionDataTaskProtocol extension

extension URLSessionDataTask: SHURLSessionDataTaskProtocol {}
