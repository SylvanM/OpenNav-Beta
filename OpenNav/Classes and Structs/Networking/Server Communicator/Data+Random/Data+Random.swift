//
//  Data+Random.swift
//  OpenNav
//
//  Created by Sylvan Martin on 1/6/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation

extension Data {
    public init?(randomOfLength length: Int) {
        var bytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
        if status == errSecSuccess {
            self.init(bytes: bytes)
        } else {
            return nil
        }
    }
}

