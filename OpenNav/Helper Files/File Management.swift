//
//  File Management.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/28/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
