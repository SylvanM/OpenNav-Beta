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
    }
    
    /// Makes a path given a start and end point
    ///
    /// - Parameters:
    ///     - start: Index indicating start
    ///     - end: Final point
    ///
    /// - Returns: Path object, or nil if there is an error
    func makePath(start: Index, end: Index) -> Path? {
        
        //Will represent a finderNode, needed for navigation
        struct finderNode{
            var type:Int;
            var row:Int;
            var col:Int;
            var floor:Int;
            var colored:Bool;
            var parentRow:Int;
            var parentCol:Int;
            var parentFloor:Int;
            init(){
                type = 1;
                row = 0;
                col = 0;
                floor = 0;
                colored = false;
                parentRow = 0;
                parentCol = 0;
                parentFloor = 0;
            }
            mutating func setType(newtype:Int){
                self.type = newtype;
            }
            mutating func setLoc(nrow:Int, ncol:Int, nfloor:Int, ncolor: Bool){
                self.row = nrow
                self.col = ncol
                self.floor = nfloor
                self.colored = ncolor
            }
            mutating func setParent(parent: finderNode){
                if (!self.colored){
                    self.parentRow = parent.row
                    self.parentCol = parent.col
                    self.parentFloor = parent.floor
                    //print(self)
                }
                
            }
            mutating func setColored(){
                self.colored = true
            }
            func getParent()->(Int,Int,Int){
                return (parentRow,parentCol,parentFloor)
            }
            
        }
        
        //Begin breadth first search method
        //queue will store nodes to be evaluated first in first out queue structure array
        var queue:Array = [finderNode]()
        var finderNodeArray:Array = [[[finderNode]]]()
        
        _ = finderNode()
        _ = 0;
        
        
        
        //fix thirdfloornodes to show 0 for halls, 2 for target, and leave as 1 for everything else
        //add first room to list
        for flr in 1...nodes!.count-1{
            for row in 0...nodes![flr].count-1{
                for col in 0...nodes![flr][row].count-1{
                    finderNodeArray[flr][row][col].setLoc(nrow: row, ncol: col, nfloor: flr, ncolor: false)
                    //if walkable or elevator set to 0
                    if (nodes![flr][row][col].value == MapNode.MapNodeValue.walkable || nodes![flr][row][col].value == MapNode.MapNodeValue.elevator){
                        finderNodeArray[flr][row][col].setType(newtype: 0);
                    }
                    //if at start room add to queue
                    if (nodes![flr][row][col].index == start){
                        queue.append(finderNodeArray[flr][row][col])
                    }
                    //if end room then set type to 2
                    if (nodes![flr][row][col].index == end){
                        finderNodeArray[flr][row][col].setType(newtype: 2)
                    }
                }
            }
        }
        
        
        
        
        var found = false;
        
        while ((!queue.isEmpty) && (found == false)){
        //pop off node and set it equal to current
            var current : finderNode
            current = queue.remove(at:0)
            
            //if current has not been visited before
            if (current.colored == false){
                //set it to colored
                let floor = current.floor
                let row = current.row
                let col = current.col
                
               finderNodeArray[floor][row][col].setColored()
                
                //if not found continue otherwise stop
                if (finderNodeArray[floor][row][col].type !=  2){
                    
                    //if row - 1 is walkable, set parent of row - 1 to current and append to queue
                    if (nodes![floor][row - 1][col].value == MapNode.MapNodeValue.walkable){
                        finderNodeArray[floor][row - 1][col].setParent(parent: current)
                        queue.append(finderNodeArray[floor][row - 1][col])
                    }
                    
                    //if row + 1 is walkable, set parent of row + 1 to current and append to queue
                    if (nodes![floor][row + 1][col].value == MapNode.MapNodeValue.walkable){
                        finderNodeArray[floor][row + 1][col].setParent(parent: current)
                        queue.append(finderNodeArray[floor][row + 1][col])
                    }
                    
                    //if col - 1 is walkable, set parent of col - 1 to current and append to queue
                    if (nodes![floor][row][col - 1].value == MapNode.MapNodeValue.walkable){
                        finderNodeArray[floor][row][col - 1].setParent(parent: current)
                        queue.append(finderNodeArray[floor][row][col - 1])
                    }
                    
                    //if col + 1 is walkable, set parent of col +1 to current and append to queue
                    if (nodes![floor][row][col + 1].value == MapNode.MapNodeValue.walkable){
                        finderNodeArray[floor][row][col + 1].setParent(parent: current)
                        queue.append(finderNodeArray[floor][row][col + 1])
                    }
                    
                    //if floor + 1 is walkable, set parent of floor + 1 to current and append to queue
                    if (nodes![floor + 1][row][col].value == MapNode.MapNodeValue.walkable){
                        finderNodeArray[floor + 1][row][col].setParent(parent: current)
                        queue.append(finderNodeArray[floor + 1][row][col])
                    }
                    
                    //if floor - 1 is walkable, set parent of floor - 1 to current and append to queue
                    if (nodes![floor - 1][row][col].value == MapNode.MapNodeValue.walkable){
                        finderNodeArray[floor - 1][row][col].setParent(parent: current)
                        queue.append(finderNodeArray[floor - 1][row][col])
                    }
                } else {
                    found = true
                }
            
            
            }
        
        
        }
        
        //By finding the end index in finderNodeArray and by finding its parent and its parent so on.... you will have the shortest path to start index
        //All we have to do now is use the indexes and assign pathNodes to them and return it
       
        
        
        
            
        
        return nil
    }
    
    
    func impose(path: Path, on images: [UIImage]) -> [UIImage]? {
        //this function will be a big pain
        //we will need to use stuff like UIGraphicsBeginImageContextWithOptions
        //and the UIImage .draw function with CGRect etc.
        //will need to get the images working first because a lot of testing is needed also it depends on how the spacing in the images which means that it will be different for each layout
        //so the values for x spacing and y spacing will also need to be stored in the webserver and it will be needed in this function
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
