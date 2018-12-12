//
//  RSA+Errors.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/5/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

extension RSA {
    
    enum RSAError: Error {
        case couldNotLoadKey
        case couldNotSaveKey
    }
    
}
