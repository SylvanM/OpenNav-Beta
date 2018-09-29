//
//  EncryptedDataHandler.swift
//  OpenNav
//
//  Created by Sylvan Martin on 9/28/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import Heimdall
import SwiftyRSA

class RSAHandler {
    func decryptData(data: Data) throws -> Data {
        if let heimdall = Heimdall(tagPrefix: "com.example") {

            if let encryptedData = heimdall.encrypt(data) {
                print("Encrypted Data: \(encryptedData)")
                print("Encrypted String: \(String(describing: String(data: encryptedData, encoding: .utf8)))")

                let decrypted = heimdall.decrypt(encryptedData)
                let decryptedString = String(data: decrypted!, encoding: .utf8)

                let keyBytes = heimdall.publicKeyData()?.bytes

                print("Decrypted String: \(decryptedString!)")
                print("Public Key: \(keyBytes?.toHexString())")
                

                return encryptedData
            }
        }

        throw EncryptingError.fail
    }
}
