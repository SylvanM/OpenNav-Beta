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

        do {
            let rsa = try RSA()
            let rsa2 = try RSA()
            
            let pub = rsa.publicKey?.stringRepresentation!
            let pub2 = rsa2.publicKey?.stringRepresentation!
            
            let keysAreTheSame = (pub == pub2)
            
            print("Keys are the same: ", keysAreTheSame)
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
