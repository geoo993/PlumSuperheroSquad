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
    
    case marvelCharacters
    case marvelCharacterComics(characterId: Int)
    case marvelComic(comicId: Int)
    case google
}

extension MockEndpoint: SHEndpointType {
    var baseURL: URL? {
        switch self {
        case .google: return URL(string: "www.google.com")
        default: return URL(string: "https://gateway.marvel.com")
        }
    }
    var path: String {
        switch self {
        case .google: return "/width=30&height=50"
        case .marvelCharacters: return "/v1/public/characters"
        case .marvelCharacterComics(let characterId): return "/v1/public/characters/\(characterId)/comics"
        case .marvelComic(let comicId): return "/v1/public/comics/\(comicId)"
        }
    }
    var method: SHHTTPMethod { return .get }
    var task: SHHTTPTask {
        switch self {
        case .google: return .request
        default:
            let publicKey = "03633e50c5a01a48febcef37fde853be"
            let privateKey = "f476d29d563b604c805f704ba4196ac5342d2a9c"
            let ts = Date().timeIntervalSince1970.description
            let hash = "\(ts)\(privateKey)\(publicKey)".md5()
            return .requestParameters(body: nil,
                                      url: ["ts":       ts,
                                            "apikey":   publicKey,
                                            "hash":     hash,
            ])
        }
    }
    var headers: SHHTTPHeaders? { return nil }
    var timeoutInterval: TimeInterval { return 30.0 }
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
    
    func request(with endPoint: MockEndpoint, completion: @escaping SHNetworkCompletion) {
        guard let url = endPoint.baseURL else {
            completion(nil, SHError.urlMissing)
            return
        }
        var request =
            URLRequest(url: url.appendingPathComponent(endPoint.path),
                       cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                       timeoutInterval: endPoint.timeoutInterval)
        request.httpMethod = endPoint.method.rawValue
        mockSession.nextDataTask = session.dataTask(with: request) { (data, response, error) in
            completion(data, error as? SHError)
        } as? MockURLSessionDataTask ?? MockURLSessionDataTask()
        mockSession.nextDataTask.resume()
    }
    
    func cancel() {
        mockSession.nextDataTask.cancel()
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

    func testMockRequestWithError() {
    
        var resultError: SHError?
        request.request(with: .google) { (data, error) in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            resultError = error
        }
        guard let error = resultError else {
           XCTFail()
           return
       }
        
        if SHAPINetworkStatusMonitor.shared.isConnected {
            XCTAssertTrue(error == SHError.unknown)
        } else {
            XCTAssertTrue(error == SHError.noConnection)
        }
    }
    
    func testMockRequestWithData() {
    
        guard let url = URL(string: "www.google.com/width=30&height=50") else {
            XCTFail()
            return
        }
        
        var resultError: SHError?
        var resultData: Data?
        let expectedString =
        """
        {
            "name": "Carnage",
            "url": "http://i.annihil.us/u/prod/marvel/i/mg/5/e0/4c0035c9c425d.gif"
        }
        """
        let expectedData = expectedString.data(using: String.Encoding.utf8)
        request.mockSession.nextData = expectedData
        request.mockSession.nextResponse = HTTPURLResponse(url: url, statusCode: 250, httpVersion: "HTTP/1.1", headerFields: nil)!
        request.request(with: .google) { (data, error) in
            resultError = error
            resultData = data
            
        }
        
        if let error = resultError, !SHAPINetworkStatusMonitor.shared.isConnected {
            XCTAssertTrue(error == SHError.noConnection)
            return
        }
        
        XCTAssertNil(resultError)
        XCTAssertNotNil(resultData)
        guard let data = resultData, let json = String(data: data, encoding: String.Encoding.utf8) else {
           XCTFail()
           return
        }
        
        XCTAssertTrue(json == expectedString)
        XCTAssertTrue(request.mockSession.nextDataTask.resumeWasCalled)
    }
    
    func testMarvelCharactersAPI() {
        
        // Given
        let marvel = SHAPIRequest<MockEndpoint>()
        let networkExpectation = expectation(description: "Wait for Marvel API to load.")
        
         // When
        var resultData: Data?
        var resultError: SHError?
        marvel.request(with: .marvelCharacters) { (data, error) in
            resultError = error
            resultData = data
            networkExpectation.fulfill()
        }
         // Then
        waitForExpectations(timeout: 5, handler: nil)

        if let error = resultError, !SHAPINetworkStatusMonitor.shared.isConnected {
            XCTAssertTrue(error == SHError.noConnection)
            return
        } else {
            XCTAssertNil(resultError)
        }
        
        guard let data = resultData else {
            XCTFail()
            return
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            XCTFail()
            return
        }
        
         guard
               let dict = json as? Dictionary<String, AnyObject>,
               let root = dict["data"] as? [String: Any],
               let total = root["total"] as? Int,
               let count = root["count"] as? Int else {
               XCTFail()
               return
           }
               
        XCTAssertTrue(total == 1493)
        XCTAssertTrue(count == 20)
    }
    
    func testCharacterComicsAPI() {
        
        // Given
        let marvel = SHAPIRequest<MockEndpoint>()
        let networkExpectation = expectation(description: "Wait for Marvel API to load.")
        
        // When
        /*
         id = 1011334;
         modified = "2014-04-29T14:18:17-0400";
         name = "3-D Man";
         resourceURI = "http://gateway.marvel.com/v1/public/characters/1011334";
         */
        var resultData: Data?
        var resultError: SHError?
        marvel.request(with: .marvelCharacterComics(characterId: 1011334)) { (data, error) in
            resultError = error
            resultData = data
            networkExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)

        // Then
       
        if let error = resultError, !SHAPINetworkStatusMonitor.shared.isConnected {
            XCTAssertTrue(error == SHError.noConnection)
            return
        } else {
            XCTAssertNil(resultError)
        }
        
        guard let data = resultData else {
            XCTFail()
            return
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            XCTFail()
            return
        }
        
        guard
            let dict = json as? Dictionary<String, AnyObject>,
            let root = dict["data"] as? [String: Any],
            let total = root["total"] as? Int,
            let results = root["results"] as? [[String: Any]] else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(total == 12)
        XCTAssertTrue(total == results.count)
    }
    
    func testComicAPI() {
        
        // Given
        let marvel = SHAPIRequest<MockEndpoint>()
        let networkExpectation = expectation(description: "Wait for Marvel API to load.")
        
        // When
        /*
         
         name = "Ant-Man & the Wasp (2010) #3";
         resourceURI = "http://gateway.marvel.com/v1/public/comics/36763";
         */
        var resultData: Data?
        var resultError: SHError?
        marvel.request(with: .marvelComic(comicId: 36763)) { (data, error) in
            resultError = error
            resultData = data
            networkExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)

        // Then
        
        if let error = resultError, !SHAPINetworkStatusMonitor.shared.isConnected {
            XCTAssertTrue(error == SHError.noConnection)
            return
        } else {
            XCTAssertNil(resultError)
        }
        
        guard let data = resultData else {
            XCTFail()
            return
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            XCTFail()
            return
        }
        
        guard
            let dict = json as? Dictionary<String, AnyObject>,
            let root = dict["data"] as? [String: Any],
            let results = root["results"] as? [[String: Any]] else {
            XCTFail()
            return
        }
        
        guard let title = results.first?["title"] as? String else {
            XCTFail()
            return
        }
        XCTAssertTrue(title == "Ant-Man & the Wasp (2010) #3")
    }
}
