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
    var originalInput: [[[String]]] // eventually this needs to be replaced with a computed value, that converts the layout BACK to a string array
    
    init(_ layout: [[[String]]], correction: [Int]) {
        //initializes the node 3d array with the string 3d array
        self.nodes = []
        self.originalInput = layout
        
        for i in 0..<layout.count {
            let floor = layout[i]
            var floorNodes: [[MapNode]] = [[]]
            
            for j in 0..<floor.count {
                let row = floor[j]
                var rowNodes: [MapNode] = []
                
                for k in 0..<row.count {
                    let index = Index(floor: i, x: k, y: j)
                    let node = row[k].toNode(index)
                    rowNodes.append(node)
                }
                floorNodes.append(rowNodes)
            }
            floorNodes.removeFirst()
            nodes!.append(floorNodes)
        }
        nodes!.removeFirst()
      
        // loops through the nodes and sets the neighbors

        for flr in 0..<nodes!.count {
            for row in 0..<nodes![flr].count {
                for col in 0..<nodes![flr][row].count {
                    
                    var current = nodes![flr][row][col]
                    
                    var index: (Int, Int, Int)
                    
                    var neighborIndices: [String : (Int, Int, Int)] = [:]
                    
                    // set top neighbor
                    index = (flr + 1, row, col)
                    if indexIsValid(index: index, for: nodes!) {
                        neighborIndices["above"] = index
                    }
                    
                    // set bottom neighbor
                    index = (flr - 1, row, col)
                    if indexIsValid(index: index, for: nodes!) {
                        neighborIndices["below"] = index
                    }
                    
                    // set front neighbor
                    index = (flr, row + 1, col)
                    if indexIsValid(index: index, for: nodes!) {
                        neighborIndices["front"] = index
                    }
                    
                    // set back neighbor
                    index = (flr, row - 1, col)
                    if indexIsValid(index: index, for: nodes!) {
                        neighborIndices["behind"] = index
                    }
                    
                    // set right neighbor
                    index = (flr, row, col + 1)
                    if indexIsValid(index: index, for: nodes!) {
                        neighborIndices["right"] = index
                    }
                    
                    // set right neighbor
                    index = (flr, row, col - 1)
                    if indexIsValid(index: index, for: nodes!) {
                        neighborIndices["left"] = index
                    }
                    
                    // now set all the neighbors
                    
                    for (key, index) in neighborIndices {
                        current.neighbors[key] = nodes![index.0][index.1][index.2]
                    }
                    
                    nodes![flr][row][col] = current
                    
                }
            }
        }
        
//        for flr in 0...nodes!.count-1 {
//            for row in 0...nodes![flr].count-1 {
//                for col in 0...nodes![flr][row].count-1 {
//                    var current = self.nodes?[flr][row][col]
//                    if (current?.value != MapNode.MapNodeValue.notWalkable) {
//                        if ((self.nodes?[flr][row].indices.contains((current?.index.y)! + 1))! && self.nodes?[flr][row+1][col].value != MapNode.MapNodeValue.notWalkable) {
//                            current?.neighbors["behind"] = self.nodes?[flr][row+1][col]
//                        }
//                        if ((self.nodes?[flr][row].indices.contains((current?.index.y)! - 1))! && self.nodes?[flr][row-1][col].value != MapNode.MapNodeValue.notWalkable) {
//                            current?.neighbors["front"] = self.nodes?[flr][row-1][col]
//                        }
//                        if ((self.nodes?[flr].indices.contains(((current?.index.x)! + 1)))! && self.nodes?[flr][row][col+1].value != MapNode.MapNodeValue.notWalkable) {
//                            current?.neighbors["right"] = self.nodes?[flr][row][col+1]
//                        }
//                        if ((self.nodes?[flr].indices.contains(((current?.index.x)! - 1)))! && self.nodes?[flr][row][col-1].value != MapNode.MapNodeValue.notWalkable) {
//                            current?.neighbors["left"] = self.nodes?[flr][row][col-1]
//                        }
//
//                        if (self.nodes?.indices.contains(flr) ?? false) && flr > 0 {
//                            //if it is a elevator then add connections to other floors
//                            if (current?.value == MapNode.MapNodeValue.elevator) {
//                                if ((self.nodes?[flr].indices.contains((current?.index.floor)! + 1))! && self.nodes?[flr+1][row][col].value != MapNode.MapNodeValue.notWalkable) {
//                                    current?.neighbors["above"] = self.nodes?[flr+1][row][col]
//                                }
//                                if ((self.nodes?[flr].indices.contains((current?.index.floor)! - 1))! && self.nodes?[flr-1][row][col].value != MapNode.MapNodeValue.notWalkable) {
//                                    current?.neighbors["below"] = self.nodes?[flr-1][row][col]
//                                }
//                            }
//                        }
//                    }
//                    self.nodes![flr][row][col] = current!
//                }
//            }
//            //corrections will be set up as floor,row,col,correct enter direction
//            //1 = right, 2 = behind, 3 = left, 4 = left
//        }
        
    }
    
    func makePath(start: Index, end: Index) throws -> Path? {
        // Make the path, and place those blue dot things on the images of the floors. Return the new image array.
        return nil
    }
    
    // MARK: Methods
    
    func indexIsValid(index: (Int, Int, Int), for array: Array<Array<Array<Any>>>) -> Bool {
        if array.indices.contains(index.0) {
            if array[index.0].indices.contains(index.1) {
                if array[index.0][index.1].indices.contains(index.2) {
                    return true
                }
            }
        }
        
        return false
    }
    
}
