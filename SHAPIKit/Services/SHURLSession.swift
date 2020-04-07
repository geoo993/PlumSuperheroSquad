//
//  SHURLSession.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 04/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

// MARK: - SHURLSessionProtocol


protocol SHURLSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> SHURLSessionDataTaskProtocol
    func handleResponse(with response: HTTPURLResponse) -> SHError
}

extension SHURLSessionProtocol {
    
    func handleResponse(with response: HTTPURLResponse) -> SHError {
        switch response.statusCode {
        case 401...500: return SHError.authenticationError
        case 501..<600: return SHError.badResponse(code: response.statusCode)
        case 600: return SHError.outdatedRequest
        default: return SHError.unknown
        }
    }
}

//MARK: - SHURLSessionDataTaskProtocol

protocol SHURLSessionDataTaskProtocol {
    func resume()
}

//MAR: - URLSession extension

extension URLSession: SHURLSessionProtocol {
    
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> SHURLSessionDataTaskProtocol {
        return (dataTask(with: request, completionHandler: completion) as URLSessionDataTask) as SHURLSessionDataTaskProtocol
    }
}

//MAR: - SHURLSessionDataTaskProtocol extension

extension URLSessionDataTask: SHURLSessionDataTaskProtocol {}
