//
//  Node.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/19/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

struct Node {
    
    var value: NodeValue
    
    init(string: String) {
        switch string {
        case "O":
            value = .walkable
        case "+":
            value = .endpoint
        case "X:":
            value = .notWalkable
        case "↕":
            value = .elevator
        default:
            value = .notWalkable
        }
    }
    
    enum NodeValue {
        case walkable    // represents a place the user could "walk through"
        case endpoint    // represents a room or location
        case notWalkable // represents a point not supported by the layout
        case elevator    // represents an entry to a new floor, can be stairs, an elevator, whatever
    }
    
}
