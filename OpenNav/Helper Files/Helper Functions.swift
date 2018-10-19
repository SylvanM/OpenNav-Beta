//
//  Helper Functions.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/19/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

// generates random base 64 number (used for
func generateRandomBase64String(length: Int) -> String {
    let digits = "ABCDEF0123456789"
    let len = UInt32(digits.count)
    
    var randomString = ""
    
    for _ in 0..<length {
        let rand = Int(arc4random_uniform(len))
        let index = digits.index(digits.startIndex, offsetBy: rand)
        let nextChar = digits[index]
        randomString += String(nextChar)
    }
    
    return randomString
}
