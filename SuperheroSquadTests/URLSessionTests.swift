//
//  URLSessionTests.swift
//  SuperheroSquadTests
//
//  Created by GEORGE QUENTIN on 05/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//


import XCTest
@testable import SHAPIKit

// MARK: - Mock URLSessionDataTask

class MockURLSessionDataTask: SHURLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    private (set) var taskCancelled = false
    func resume() {
        resumeWasCalled = true
    }
    
    func cancel() {
        taskCancelled = true
    }
}

// MARK: - Mock URLSession

class MockURLSession: SHURLSessionProtocol {
 
    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURL: URL?
    var nextData: Data?
    var nextResponse: URLResponse?
    var nextError: SHError?
    
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> SHURLSessionDataTaskProtocol {
        lastURL = request.url
        if let status = SHAPINetworkStatusMonitor.shared.status, status == .offline {
            completion(nil, nil, SHError.noConnection)
        } else {
            if let error = nextError {
                completion(nextData, nextResponse, SHError.failed(error.localizedDescription))
            } else if let response = nextResponse as? HTTPURLResponse {
                if 200..<300 ~= response.statusCode {
                    completion(nextData, response, nil)
                } else {
                    let responseError = self.handleResponse(with: response)
                    completion(nextData, response, responseError)
                }
            } else {
                completion(nextData, nextResponse, SHError.unknown)
            }
        }
        return nextDataTask
    }
}

class URLSessionTests: XCTestCase {

    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testURLSessionURL() {
        // Given
        let urlString = "www.google.com"
        
        // When
        guard SHAPINetworkStatusMonitor.shared.isConnected else { return }
        guard let url = URL(string: urlString) else {
            XCTFail()
            return
        }
        
        XCTAssertNil(session.lastURL)
        
        let request = URLRequest(url: url)
        var resultError: SHError?
        _ = session.dataTask(with: request) { (data, response, error) in
            XCTAssertNil(data)
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            resultError = error as? SHError
        }
        
        // Then
        
        XCTAssertTrue(session.lastURL == url)
        guard let error = resultError else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(error == SHError.unknown)
    }
    
    func testURLSessionDataTaskResume() {
        // Given
        let urlString = "www.google.com"
        
        // When
        guard let url = URL(string: urlString) else {
            XCTFail()
            return
        }
        
        session.nextDataTask = MockURLSessionDataTask()
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            XCTAssertNil(data)
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }
        
        XCTAssertFalse(session.nextDataTask.resumeWasCalled)
        
        task.resume()
        
        // Then
        XCTAssertTrue(session.lastURL == url)
        XCTAssertTrue(session.nextDataTask.resumeWasCalled)
    }
    
    func testURLSessionError() {
        
        // Given
        let urlString = "www.google.com"
        
        // When
        
        guard SHAPINetworkStatusMonitor.shared.isConnected else { return }
        
        guard let url = URL(string: urlString) else {
            XCTFail()
            return
        }
        
        XCTAssertNil(session.nextError)
        
        session.nextError = SHError.noConnection
        
        var resultError: SHError?
        let request = URLRequest(url: url)
        _ = session.dataTask(with: request) { (data, response, error) in
            XCTAssertNil(data)
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            resultError = error as? SHError
        }
        
        // Then
        guard let error = resultError else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(error.localizedDescription == "Error: Please connect to the internet")
        
    }
    
    func testURLSessionSuccessResponse() {
        
        // Given
        let urlString = "www.google.com"
        
        // When
        guard SHAPINetworkStatusMonitor.shared.isConnected else { return }
        guard let url = URL(string: urlString) else {
            XCTFail()
            return
        }
        
        var httpReponse: HTTPURLResponse?
        let request = URLRequest(url: url)
        let expectedData =
        """
        {
            title: "Marvel",
            data: {
                comics: 12,
                characters: 29
            }
        }
        """.data(using: String.Encoding.utf8)
        session.nextData = expectedData
        session.nextDataTask = MockURLSessionDataTask()
        session.nextResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        let task = session.dataTask(with: request) { (data, response, error) in
            XCTAssertNotNil(data)
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            
            httpReponse = response as? HTTPURLResponse
        }
        
        task.resume()
        
        // Then
        XCTAssertTrue(session.lastURL == url)
        XCTAssertTrue(httpReponse?.url == url)
        XCTAssertTrue(httpReponse?.statusCode == 200)
        XCTAssertTrue(session.nextDataTask.resumeWasCalled)
    }
    
    func testURLSessionFailureResponse() {
        // Given
        let urlString = "www.google.com"
        
        // When
        guard SHAPINetworkStatusMonitor.shared.isConnected else { return }
        guard let url = URL(string: urlString) else {
            XCTFail()
            return
        }
        
        var httpReponse: HTTPURLResponse?
        var resultError: SHError?
        let request = URLRequest(url: url)
        session.nextData = nil
        session.nextDataTask = MockURLSessionDataTask()
        session.nextResponse = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: "HTTP/1.1", headerFields: nil)!
        let task = session.dataTask(with: request) { (data, response, error) in
            XCTAssertNil(data)
            XCTAssertNotNil(response)
            XCTAssertNotNil(error)
            
            httpReponse = response as? HTTPURLResponse
            resultError = error as? SHError
        }
        
        task.resume()
        
        // Then
        guard let error = resultError else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(session.lastURL == url)
        XCTAssertTrue(httpReponse?.url == url)
        XCTAssertTrue(httpReponse?.statusCode == 401)
        XCTAssertTrue(session.nextDataTask.resumeWasCalled)
        XCTAssertTrue(error == SHError.authenticationError)
    }
    
    func testURLSessionSuccessData() {
        // Given
        let urlString = "www.google.com"

        // When
        guard SHAPINetworkStatusMonitor.shared.isConnected else { return }
        guard let url = URL(string: urlString) else {
           XCTFail()
           return
        }

        var httpReponse: HTTPURLResponse?
        var resultString: String?
        var resultData: Data?
        let request = URLRequest(url: url)
        let expectedString =
        """
        {
           title: "Marvel",
           data: {
               comics: 12,
               characters: 29
           }
        }
        """
        let expectedData = expectedString.data(using: String.Encoding.utf8)
        session.nextData = expectedData
        session.nextDataTask = MockURLSessionDataTask()
        session.nextResponse = HTTPURLResponse(url: request.url!, statusCode: 250, httpVersion: "HTTP/1.1", headerFields: nil)!
        let task = session.dataTask(with: request) { (data, response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            resultData = data
            guard let dataResult = resultData else {
               XCTFail()
               return
            }
            resultString = String(data: dataResult, encoding: String.Encoding.utf8)
            httpReponse = response as? HTTPURLResponse
        }
        
        task.resume()
        
        guard let json = resultString else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(json == expectedString)
        XCTAssertTrue(expectedData == resultData!)
        XCTAssertTrue(session.lastURL == url)
        XCTAssertTrue(httpReponse?.url == url)
        XCTAssertTrue(httpReponse?.statusCode == 250)
        XCTAssertTrue(session.nextDataTask.resumeWasCalled)
        
    }

}
