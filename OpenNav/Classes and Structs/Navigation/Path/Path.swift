//
//  Path.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/21/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

struct Path {
    
    // returns floor
    subscript(_ index: Int) -> [[PathNode]] {
        get {
            return nodes[index]
        }
    }
    
    var nodes: [[[PathNode]]]
    
    struct PathNode: Node {
        var neighbors: (Node?, Node?, Node?, Node?, Node?, Node?)
        var index: Index
        var value: PathNodeValue
        
        enum PathNodeValue {
            case forwards
            case backwards
            case left
            case right
            case up
            case down
            case blank
        }
    }
}
