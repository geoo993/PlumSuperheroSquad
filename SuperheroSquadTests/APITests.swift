//
//  APITests.swift
//  SuperheroSquadTests
//
//  Created by GEORGE QUENTIN on 05/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//


import XCTest
@testable import SuperheroSquad

// MARK: - Mock URLSessionDataTask

class MockURLSessionDataTask: SHURLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
}

// MARK: - Mock URLSession

class MockURLSession: SHURLSessionProtocol {
 
    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURL: URL?
    var nextData: Data?
    var nextResponse: URLResponse?
    var nextError: Error?
    
    private func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> SHURLSessionDataTaskProtocol {
        lastURL = request.url
        if let error = nextError {
            completion(nextData, nextResponse, SHError.failed(error.localizedDescription))
        } else if let response = nextResponse as? HTTPURLResponse, 200..<300 ~= response.statusCode {
            completion(nextData, response, nil)
        } else {
            if let response = nextResponse as? HTTPURLResponse {
                completion(nextData, nextResponse, SHError.badResponse(code: response.statusCode))
            } else {
                completion(nextData, nextResponse, SHError.unknown)
            }
        }
        return nextDataTask
    }
}

// MARK: - Mock Endpoint

enum MockEndpoint {
    
    case google
}

extension MockEndpoint: SHEndpointType {
    var baseURL: URL? { return URL(string: "www.google.com") }
    var path: String { return "" }
    var method: SHHTTPMethod { return .get }
    var task: SHHTTPTask { return .request }
    var headers: SHHTTPHeaders? { return nil }
    var timeoutInterval: TimeInterval { return 10.0}
}

// MARK: - Mock Request

class MockAPIRequest<SHEndpoint: SHEndpointType>: SHURLRequestProtocol {
    

    // MARK: - Poperties

    let mockSession: MockURLSession
    var session: SHURLSessionProtocol { return mockSession }

    // MARK: - Initialisers

    init(session: MockURLSession = MockURLSession()) {
        self.mockSession = session
    }
    
    // MARK: Helpers
    
    
    func request(with endpoint: SHEndpoint, completion: @escaping SHNetworkCompletion) {
        
    }
    
    func cancel() {
        
    }
    
}



class APITests: XCTestCase {

    var request: MockAPIRequest<MockEndpoint>!
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        request = MockAPIRequest(session: session)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testURLSession() {
        // Given
        let urlString = "www.google.com"
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        
        // When
        guard let url = URL(string: urlString) else {
            XCTFail()
            return
        }
        
        // Continue
    }
    
    
    func testURLSessionResume() {
        // Given
        let urlString = "www.google.com"
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        
        // When
        guard let url = URL(string: urlString) else {
            XCTFail()
            return
        }
        
        // Continue
    }

    
    func testFetchDataResponse() {
        // Given
        guard let url = URL(string: "www.google.com") else {
            XCTFail()
            return
        }
        let expectedData = "{}".data(using: String.Encoding.utf8)
        session.nextData = expectedData
        session.nextResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: [:])
        var actualData: Data?
        
        // Continue
    }

    
}
