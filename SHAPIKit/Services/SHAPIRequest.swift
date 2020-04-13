//
//  SHAPIRequest.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 05/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

//MARK: - SHURLRequestProtocol

typealias SHNetworkCompletion = (_ data: Data?,_ error: SHError?) -> Void

protocol SHURLRequestProtocol: class {
    associatedtype SHEndpoint: SHEndpointType
    var session: SHURLSessionProtocol { get }
    func request(with endpoint: SHEndpoint, completion: @escaping SHNetworkCompletion)
    func cancel()
}

//MARK: - SHAPIRequest

class SHAPIRequest<SHEndpoint: SHEndpointType>: SHURLRequestProtocol {
    
    // MARK: - Poperties

    var task: URLSessionDataTask?
    let session: SHURLSessionProtocol
    
    // MARK: - Initialisers
    
    init(session: SHURLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Requests
    
    func request(with endpoint: SHEndpoint, completion: @escaping SHNetworkCompletion) {
        do {
            let request = try self.request(from: endpoint)
            task = session.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                if let status = SHAPINetworkStatusMonitor.shared.status, status == .offline {
                    completion(nil, SHError.noConnection)
                } else {
                    if let error = error {
                        completion(nil, SHError.failed(error.localizedDescription))
                    } else if let response = response as? HTTPURLResponse {
                        if 200..<300 ~= response.statusCode {
                            completion(data, nil)
                        } else {
                            let responseError = self.session.handleResponse(with: response)
                            completion(nil, responseError)
                        }
                    } else {
                        completion(nil, nil)
                    }
                }
            } as? URLSessionDataTask
        } catch {
            completion(nil, SHError.dataTaskFailed)
        }
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    // MARK: - Helpers
    
    fileprivate func request(from endPoint: SHEndpoint) throws -> URLRequest {
        guard let url = endPoint.baseURL else { throw SHError.urlMissing }
        var request = URLRequest(url: url.appendingPathComponent(endPoint.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: endPoint.timeoutInterval)
        request.httpMethod = endPoint.method.rawValue
        do {
            switch endPoint.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters, let urlParameters):
                try self.configureParameters(body: bodyParameters, url: urlParameters, request: &request)
            case .requestParametersAndHeaders(let bodyParameters, let urlParameters, let headers):
                self.addAdditionalHeaders(with: headers, request: &request)
                try self.configureParameters(body: bodyParameters, url: urlParameters, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(body: SHParameters?, url: SHParameters?, request: inout URLRequest) throws {
        do {
            if let bodyParameters = body {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = url {
                try SHURLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(with headers: SHHTTPHeaders?, request: inout URLRequest) {
        guard let httpHeaders = headers else { return }
        for (key, value) in httpHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}
