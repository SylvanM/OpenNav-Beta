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
            
            let plaintext = "secret"
            let plainData = plaintext.data(using: .utf8)
            
            let encryptedData = rsa.encrypt(plainData!)
            
            let decryptedData = rsa.decrypt(encryptedData)
            
            let decryptedText = String(data: decryptedData, encoding: .utf8)
            
            if decryptedText == plaintext {
                print("Crypto successful")
                print("Decrypted: \(String(describing: decryptedText))")
            } else {
                print("Decryption failed")
                print("Decrypted: \(String(describing: decryptedText))")
            }
        } catch {
            print(error)
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
