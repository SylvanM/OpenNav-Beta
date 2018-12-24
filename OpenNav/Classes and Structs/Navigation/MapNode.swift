//
//  MapNode.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/21/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

struct MapNode: Node {
    var neighbors: (Node?, Node?, Node?, Node?, Node?, Node?)
    var index: Index
    
    var value: MapNodeValue
    
    init(string: String, index: Index) {
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
        
        self.index = index
    }
    
    enum MapNodeValue {
        case walkable    // represents a place the user could "walk through"
        case endpoint    // represents a room or location
        case notWalkable // represents a point not supported by the layout
        case elevator    // represents an entry to a new floor, can be stairs, an elevator, whatever
    }
}
