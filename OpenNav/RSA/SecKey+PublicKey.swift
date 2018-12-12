//
//  SecKey+PublicKey.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/12/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import Security

extension SecKey {
    var publicKey: SecKey {
        return SecKeyCopyPublicKey(self)!
    }
}
