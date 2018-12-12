//
//  RSA+Key Generation.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/2/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

extension RSA {
    
    class func generateKeys() throws -> (SecKey?, SecKey?) {
        
        let tag = "com.OpenNav.keys.deviceKeys".data(using: .utf8)
        
        let attributes: [String : Any] = [
            kSecAttrKeyType as String:            kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String:      2048,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String:    true,
                kSecAttrApplicationTag as String: tag as Any
            ]
        ]
        
        var error: Unmanaged<CFError>?
        
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
//        let status = SecItemAdd(attributes as CFDictionary, nil)
//        guard status == errSecSuccess else { throw RSAError.couldNotSaveKey }
        
        let publicKey = SecKeyCopyPublicKey(privateKey)!
        
        return (publicKey, privateKey)
        
    }
    
    class func generateFromBundle() throws -> RSA {
        let keychain = KeychainHelper()
        
        if let privateKey = keychain.getKey(), let publicKey = SecKeyCopyPublicKey(privateKey) {
            return RSA((publicKey, privateKey))
        }
        
        throw RSAError.couldNotLoadKey
    }
    
}
