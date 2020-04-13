//
//  DataModelTests.swift
//  SuperheroSquadTests
//
//  Created by GEORGE QUENTIN on 13/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import XCTest
@testable import SHData

class DataModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: - Safe Collection
   
    func testPagination() {

        let page = SHPagination(count: 25, limit: 0, offset: 25, total: 145)
        XCTAssertTrue(page.count == 25)
        XCTAssertTrue(page.limit == 0)
        XCTAssertTrue(page.offset == 25)
        XCTAssertTrue(page.total == 145)
        XCTAssertTrue(page.nextOffset == 25)
        XCTAssertTrue(page.isNextListAvailable)
        
        let page2 = SHPagination(count: 50, limit: 25, offset: 50, total: 145)
        XCTAssertTrue(page2.count == 50)
        XCTAssertTrue(page2.limit == 25)
        XCTAssertTrue(page2.offset == 50)
        XCTAssertTrue(page2.total == 145)
        XCTAssertTrue(page2.nextOffset == 75)
        XCTAssertTrue(page2.isNextListAvailable)
        
        let page3 = SHPagination(count: 70, limit: 75, offset: 70, total: 145)
        XCTAssertTrue(page3.count == 70)
        XCTAssertTrue(page3.limit == 75)
        XCTAssertTrue(page3.offset == 70)
        XCTAssertTrue(page3.total == 145)
        XCTAssertTrue(page3.nextOffset == 145)
        XCTAssertTrue(page3.isNextListAvailable)
        
        let page4 = SHPagination(count: 20, limit: 125, offset: 50, total: 145)
        XCTAssertTrue(page4.count == 20)
        XCTAssertTrue(page4.limit == 125)
        XCTAssertTrue(page4.offset == 50)
        XCTAssertTrue(page4.total == 145)
        XCTAssertTrue(page4.nextOffset == 175)
        XCTAssertFalse(page4.isNextListAvailable)
    }
  
    func testImageResourse() {
        
        let imageURLString = "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"
        guard let imageResource = SHImageResource(from: imageURLString) else {
            XCTFail()
            return
        }
        XCTAssertTrue(imageResource.url.absoluteString == imageURLString)
        XCTAssertTrue(imageResource.lastPathComponent == "535fecbbb9784")
        
        let imageURLString2 = "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg"
        guard let imageResource2 = SHImageResource(from: imageURLString2) else {
           XCTFail()
           return
        }
        XCTAssertTrue(imageResource2.url.absoluteString == imageURLString2)
        XCTAssertTrue(imageResource2.lastPathComponent == "image_not_available")
        
        let imageURLString3 = ""
        let imageResource3 = SHImageResource(from: imageURLString3)
        XCTAssertNil(imageResource3)
        
        let jsonString =
        """
        {
           "path": "http://i.annihil.us/u/prod/marvel/i/mg/5/e0/4c0035c9c425d",
           "extension": "gif"
        }
        """
        guard let expectedData = jsonString.data(using: String.Encoding.utf8) else {
            XCTFail()
            return
        }
        
        guard let imageResource4 = try? JSONDecoder().decode(SHImageResource.self, from: expectedData) else {
            XCTFail()
            return
        }
    
        XCTAssertTrue(imageResource4.url.absoluteString == "http://i.annihil.us/u/prod/marvel/i/mg/5/e0/4c0035c9c425d.gif")
        XCTAssertTrue(imageResource4.lastPathComponent == "4c0035c9c425d")
        
    }
      
}
