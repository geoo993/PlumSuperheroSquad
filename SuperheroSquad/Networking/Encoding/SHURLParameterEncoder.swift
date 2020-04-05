//
//  SHURLParameterEncoder.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 05/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

struct SHURLParameterEncoder: SHParameterEncoder {
    
    static func encode(urlRequest: inout URLRequest, with parameters: SHParameters) throws {
        guard let url = urlRequest.url else { throw SHError.urlMissing }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
