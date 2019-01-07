//
//  Key Upload.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/22/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import Alamofire

extension ServerCommunicator {
    
    func uploadKey(for appID: String, key: SecKey) {
        
        // make some random data and encrypt it, then sign it.
        let data = Data(randomOfLength: 8)!
        
        // encrypt random data to sign it
        let algorithm: SecKeyAlgorithm = .rsaSignatureMessagePKCS1v15SHA512
        
        var signError: Unmanaged<CFError>?
        var encrError: Unmanaged<CFError>?
        
        let encrypted = SecKeyCreateEncryptedData(key.publicKey, .rsaEncryptionPKCS1, data as CFData, &encrError) as Data?
        let signature = SecKeyCreateSignature(key, algorithm, data as CFData, &signError)! as Data
        
        print("Encryption error: ", encrError)
        print("Signature error:  ", signError)
        
        let arguments: [String : String] = [
            "id" : appID,
            "key": key.publicKey.stringRepresentation!,
            "data": encrypted!.base64EncodedString(),
            "signature": signature.base64EncodedString()
        ]
        
//        let testRequest   = UserRequest(.testUser, arguments: arguments)
        let addRequest    = UserRequest(.addUser, arguments: arguments)
//        let updateRequest = UserRequest(.updateUser, arguments: arguments)
        
        Alamofire.request(addRequest.url).responseString { (response) in
            print("Requested: ", addRequest.url)
            let response = response.data
            print(response)
        }
    }
    
}
