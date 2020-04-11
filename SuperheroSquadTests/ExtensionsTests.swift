//
//  ExtensionsTests.swift
//  SuperheroSquadTests
//
//  Created by GEORGE QUENTIN on 02/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import XCTest
@testable import SuperheroSquad

class ExtensionsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: - Safe Collection
   
   func testSafeCollection() {
       let array = [200, 300, 401, 403, 405, 409, 500, 600]
       let safeFail = array[safe: 33]
       XCTAssertNil(safeFail)
       
       guard let safeCode = array[safe: 3] else {
           XCTFail()
           return
       }
       
       XCTAssertTrue(safeCode == 403)
   }
    
    func testTupleArray() {
        let array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        let result = array.tuple()
        
        XCTAssertTrue(result.count == 5)
        XCTAssertNotNil(result[0].1)
        XCTAssertNotNil(result[1].1)
        XCTAssertNotNil(result[2].1)
        XCTAssertNotNil(result[3].1)
        XCTAssertNil(result[4].1)
    }
    
    func testTupleArrayMeasured() {
        self.measure {
            _ = [0..<1000000].flatMap{$0}.tuple()
        }
    }
       
}
