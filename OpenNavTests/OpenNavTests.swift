//
//  OpenNavTests.swift
//  OpenNavTests
//
//  Created by Sylvan Martin on 9/8/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import OpenNav

class OpenNavTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        do {
            let jsonString = "{\"key\":\"keyyy\",\"iv\":\"ivvv\"}"
            let data = jsonString.data(using: .ascii)
            let json = try JSON(data: data!)
            print("Json: ", json)
        } catch {
            print("ERROR: \(error)")
        }
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
