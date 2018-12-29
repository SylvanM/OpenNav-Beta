//
//  OpenNavTests.swift
//  OpenNavTests
//
//  Created by Sylvan Martin on 9/8/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import XCTest
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
       
        let picker = UIPickerView()
        picker.tag = 1
        let picker2 = UIPickerView()
        
        print("Tag1: ", picker.tag)
        print("Tag2: ", picker2.tag)
        print("Label: ", picker.accessibilityAttributedLabel)
        print("Debug Description", picker.debugDescription)
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
