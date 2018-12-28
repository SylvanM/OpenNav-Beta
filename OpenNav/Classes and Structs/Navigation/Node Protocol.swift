//
//  Node.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/21/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

protocol Node {
    
    var index: Index { get set }
    var neighbors: [String : Node?] { get set }
    // in order:
    // left, in front, right, behind, below, above
}
