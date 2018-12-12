//
//  KeychainHelper.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/12/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

struct KeychainHelper {
    
    let tag = "com.OpenNav.keys.deviceKey".data(using: .utf8)!
    
    func getKey() -> SecKey? {
        let getquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: tag,
                                       kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                                       kSecReturnRef as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else { return nil }
        let key = item as! SecKey
        
        return key
    }
    
    func saveKey(_ key: SecKey) {
        let addquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: tag,
                                       kSecValueRef as String: key]
        
        let status = SecItemAdd(addquery as CFDictionary, nil)
        do {
            guard status == errSecSuccess else { throw KeychainError.couldNotSave }
        } catch {
            print("could not save: ", error)
        }
        
    }
    
    enum KeychainError: Error {
        case couldNotSave
    }
    
}
