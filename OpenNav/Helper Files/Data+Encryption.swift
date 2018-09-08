//
//  Data+Encryption.swift
//  Navigate HoCo
//
//  Created by Sylvan Martin on 8/22/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import CryptoSwift

extension Data {
    // Crypto routines to encrypt or decrypt any data

    // MARK: AES-GCM

    func encrypt(key: Data, iv: Data) throws -> Data {

        // Hash data
        let hashedData = self.sha256()
        let bytes = hashedData.bytes

        do {
            let cbc = CBC(iv: iv.bytes)
            let aes = try AES(key: key.bytes, blockMode: cbc)

            let encryptedBytes = try aes.encrypt(self.bytes)
            let encryptedData = Data(bytes: encryptedBytes)

            return encryptedData
        } catch {
            throw error
        }
    }

    func decrypt(key: Data, iv: Data) throws -> Data {

        // Hash data
        /*
        let hashedData = self.sha256()
        let bytes = hashedData.bytes
        */

        do {
            let cbc = CBC(iv: iv.bytes)
            let aes = try AES(key: key.bytes, blockMode: cbc, padding: .pkcs7)

            let decryptedBytes = try aes.decrypt(self.bytes)
            let decryptedData = Data(bytes: decryptedBytes)

            return decryptedData
        } catch {
            throw error
        }
    }

}
