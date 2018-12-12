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
        
        
        
        let responded = self.expectation(description: "responded")

        do {
//            let rsa = try RSA.generateFromBundle()
            let rsa = try RSA()
            
            let server = ServerCommunicator()

            let arguments: [String : String] = [
                "plaintext": "hhhhhhhhhh",
                "key": (rsa.publicKey?.export())!
            ]

            let request = ServerCommunicator.CryptoRequest(arguments: arguments)

            server.test(request) { (data) in
                
                let encrypted = String(data: data, encoding: .ascii)
                print(encrypted)

                let decrypted = rsa.decrypt(data)
                let decryptedText = String(data: decrypted, encoding: .utf8)
                print("decrypted: ", decryptedText)

                responded.fulfill()
            }
            
        } catch {
            print(error)
            responded.fulfill()
            self.recordFailure(withDescription: "Could not find keys", inFile: "OpenNavTests.swift", atLine: 36, expected: true)
        }
        
        self.wait(for: [responded], timeout: 30)
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
