//
//  ExtensionsTests.swift
//  SuperheroSquadTests
//
//  Created by GEORGE QUENTIN on 02/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import XCTest
@testable import SHCore

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
    
       let safeFail2 = array[safe: -3]
       XCTAssertNil(safeFail2)
       
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
        XCTAssertTrue(result[3].0 == 7)
        XCTAssertTrue(result[3].1 == 8)
        XCTAssertNil(result[4].1)
        XCTAssertTrue(result[4].0 == 9)
        
        let array2 = Array(array.dropLast())
        let result2 = array2.tuple()
        XCTAssertTrue(result2.count == 4)
        XCTAssertNotNil(result2[0].1)
        XCTAssertTrue(result2[0].1 == 2)
        XCTAssertNotNil(result2[1].1)
        XCTAssertTrue(result2[1].1 == 4)
        XCTAssertNotNil(result2[2].1)
        XCTAssertTrue(result2[2].1 == 6)
        XCTAssertNotNil(result2[3].1)
        XCTAssertTrue(result2[3].1 == 8)
    }
    
    func testTupleArrayMeasured() {
        self.measure {
            _ = [0..<1000000].flatMap{$0}.tuple()
        }
    }
    
    func testBoundingBox() {
        let text = "Super Hero Squad"
        let rect = text.boundingBox(constrainedWith: 10, font: SHFontStyle.marvel(35).font)
        XCTAssertTrue(rect.height > 300)
        XCTAssertTrue(rect.height < 500)
        
        let free = "💪 Recruit to Squad"
        let rect2 = free.boundingBox(constrainedWith: 0, font: SHFontStyle.title3.font)
        XCTAssertTrue(rect2.height < 30)
        
        let rect3 = free.boundingBox(constrainedWith: 200, font: SHFontStyle.title3.font)
        XCTAssertTrue(rect3.height < 30)
        
        let hired = "🔥 Fire from Squad"
        let rect4 = hired.boundingBox(constrainedWith: 200, font: SHFontStyle.subhead.font)
        XCTAssertTrue(rect4.height < 20)
    }
    
    func testHeightWithConstrainedWidth() {
        
        let hired = "🔥 Fire from Squad"
        let height = hired.heightWithConstrainedWidth(width: 10, font: SHFontStyle.subhead.font)
        XCTAssertTrue(height > 200)
        XCTAssertTrue(height < 250)
        
        let height2 = hired.heightWithConstrainedWidth(width: 300, font: SHFontStyle.subhead.font)
        XCTAssertTrue(height2 < 20)
        
        let free = "💪 Recruit to Squad"
        let height3 = free.heightWithConstrainedWidth(width: 10, font: SHFontStyle.title1.font)
        XCTAssertTrue(height3 > 600)
        XCTAssertTrue(height3 < 650)
        
        let height4 = free.heightWithConstrainedWidth(width: 10, font: SHFontStyle.body.font)
        XCTAssertTrue(height4 > 200)
        XCTAssertTrue(height4 < 300)
        
    }
    
      
}
