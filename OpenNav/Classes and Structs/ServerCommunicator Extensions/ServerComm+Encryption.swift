//
//  ServerComm+Encryption.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/10/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

extension ServerCommunicator {
    
    struct CryptoRequest: Request {
        
        let cryptoUrl = domain + "crypto/crypto.php?f=encrypt"
        
        var arguments: [String : String]
        
        func url() -> URL {
            var urlString = cryptoUrl
            
            for (arg, value) in arguments {
                if arg == "key" {
                    urlString += String("&\(arg)=\(value)")
                } else {
                    urlString += String("&\(arg)=\(value)")
                }
            }
            
            let url = URL(string: urlString)!
            
            print("URL: ", urlString)
            
            return url
        }
        
    }
    
}
