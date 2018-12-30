//
//  SecKey+Exportation.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/2/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import Security

extension SecKey {
    
    var stringRepresentation: String? {
        
        var error: Unmanaged<CFError>?
        
        if let cfdata = SecKeyCopyExternalRepresentation(self, &error) {
            let data: Data = cfdata as Data
            let b64Key = data.base64EncodedString()
            
            return b64Key
        } else {
            print("exportation error: ", error as Any)
            return nil
        }
        
    }
    
}
