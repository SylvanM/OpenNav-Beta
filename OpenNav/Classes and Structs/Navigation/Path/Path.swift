//
//  Path.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/19/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

class Path {
    
    var nodes: [[[PathNode]]]
    var layout: Layout
    
    init(_ nodes: [[[PathNode]]]) {
        self.nodes = nodes
    }
    
    struct PathNode {
        
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
