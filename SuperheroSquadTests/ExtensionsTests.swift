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

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
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
       
}
