//
//  Errors.swift
//  Navigate HoCo
//
//  Created by Sylvan Martin on 8/24/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

enum DataLoadingError: Error {
    case couldNotLoadData
}

enum EncryptingError: Error {
    case fail
}
