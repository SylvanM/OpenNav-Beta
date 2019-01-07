//
//  RSA+Crypto.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/2/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

extension RSA {
    
    func encrypt( _ data: Data) -> Data {
        var error: Unmanaged<CFError>?
        
        let cfdata = data as NSData as CFData
        let encryptedCFData = SecKeyCreateEncryptedData(publicKey!, algorithm, cfdata, &error)
        
        print("encryption error: ", error as Any)
        
        return encryptedCFData as! NSData as Data
    }
    
    func decrypt(_ data: Data) -> Data {        
        var error: Unmanaged<CFError>?
        
        let cfdata = data as NSData as CFData
        let decryptedCFData = SecKeyCreateDecryptedData(privateKey!, algorithm, cfdata, &error)
        
        print("decryption error: ", error as Any)
        
        let decryptedData = decryptedCFData! as Data
        return decryptedData
    }
    
}
