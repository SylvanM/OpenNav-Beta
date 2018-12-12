//
//  KeyGeneration.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/2/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import Security

class RSA {
    
    let algorithm = SecKeyAlgorithm.rsaEncryptionPKCS1
    
    var publicKey: SecKey?
    var privateKey: SecKey?
    
    init() throws {
        (self.publicKey, self.privateKey) = try RSA.generateKeys()
    }
    
    init(_ keys: (SecKey?, SecKey?)) {
        (self.publicKey, self.privateKey) = keys
    }
    
    init(publicKey: SecKey, privateKey: SecKey) {
        (self.publicKey, self.privateKey) = (publicKey, privateKey)
    }
    
}
