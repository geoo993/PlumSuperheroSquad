//
//  APIRequestTests.swift
//  SuperheroSquadTests
//
//  Created by GEORGE QUENTIN on 05/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import XCTest
@testable import SHAPIKit

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

class APIRequestTests: XCTestCase {

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

    func testRequest() {
        
    }
}
