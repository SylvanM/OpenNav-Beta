//
//  Navigator.swift
//  Navigate HoCo
//
//  Created by Sylvan Martin on 8/26/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import UIKit

enum NavigationError: Error {
    case noSuchRoomInBuilding
    case layoutNotRoutable
}

class Layout {
    
    var nodes: [[[MapNode]]]
    
    init(_ layout: [[[String]]]) {
        var tempNodeArray: [[[MapNode?]?]?]
        tempNodeArray = [[[MapNode?]?]?](repeating: nil, count: layout.count)
        
        for i in 0..<layout.count {
            let floor = layout[i]
            var nodeFloor = [[MapNode?]?](repeating: nil, count: layout.count)
            for j in 0..<floor.count {
                let row = floor[j]
                var nodeRow: [MapNode?] = [MapNode?](repeating: nil, count: row.count)
                for k in 0..<row.count {
                    let column = row[k]
                    var tempNode = MapNode(string: column, index: Index(floor: i, x: k, y: j))
                    tempNode.neighbors = (nodeRow[k - 1], nodeFloor[j - 1]?[k], nodeRow[k + 1], nodeFloor[j + 1]?[k], tempNodeArray[i - 1]?[j]?[k], tempNodeArray[i + 1]?[j]?[k])
                    nodeRow[k] = tempNode
                }
                nodeFloor[j] = nodeRow
            }
            tempNodeArray[i] = nodeFloor
        }
        
        self.nodes = tempNodeArray as! [[[MapNode]]]
    }
    
    func makePath(start: Node, end: Node, correction: [Int]) throws -> Path? {
        // Make the path, and place those blue dot things on the images of the floors. Return the new image array.
        return nil
    }
    
}
