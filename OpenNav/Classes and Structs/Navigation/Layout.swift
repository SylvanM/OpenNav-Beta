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
    
    var nodes: [[[MapNode]]]?
    
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
                    
                    var leftNode   : Node? = nil
                    var frontNode  : Node? = nil
                    var rightNode  : Node? = nil
                    var backNode   : Node? = nil
                    var topNode    : Node? = nil
                    var bottomNode : Node? = nil
                    
                    if nodeRow.indices.contains(k - 1) {
                        leftNode = nodeRow[k - 1]
                    }
                    if nodeFloor.indices.contains(j - 1), nodeFloor[j - 1]?.indices.contains(k) ?? false {
                        frontNode = nodeFloor[j - 1]?[k]
                    }
                    if nodeRow.indices.contains(k + 1) {
                        rightNode = nodeRow[k + 1]
                    }
                    if nodeFloor.indices.contains(j + 1), nodeFloor[j + 1]?.indices.contains(k) ?? false {
                        backNode = nodeFloor[j + 1]?[k]
                    }
                    if tempNodeArray.indices.contains(i - 1), tempNodeArray[i - 1]?.indices.contains(j) ?? false, tempNodeArray.indices.contains(k) {
                        topNode = tempNodeArray[i - 1]?[j]?[k]
                    }
                    if tempNodeArray.indices.contains(i + 1), tempNodeArray[i + 1]?.indices.contains(j) ?? false, tempNodeArray.indices.contains(k) {
                        bottomNode = tempNodeArray[i + 1]?[j]?[k]
                    }
                    
                    tempNode.neighbors = (leftNode, frontNode, rightNode, backNode, topNode, bottomNode) as (Node?, Node?, Node?, Node?, Node?, Node?)
                    nodeRow[k] = tempNode
                }
                nodeFloor[j] = nodeRow
            }
            tempNodeArray[i] = nodeFloor
        }
        self.nodes = tempNodeArray as? [[[MapNode]]]
    }
    
    func makePath(start: Node, end: Node, correction: [Int]) throws -> Path? {
        // Make the path, and place those blue dot things on the images of the floors. Return the new image array.
        return nil
    }
    
}
