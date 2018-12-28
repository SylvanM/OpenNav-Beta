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
        self.nodes = [[[]]]
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
            self.nodes!.append(floorNodes)
        }
        
        print("Nodes: ", self.nodes)
      
        //loops through the nodes and sets the neighbors
        
        for flr in 0...layout.count-1{
            for row in 0...layout[flr].count-1{
                for col in 0...layout[flr][row].count-1{
                    var current = self.nodes?[flr][row][col]
                    if (current?.value != MapNode.MapNodeValue.notWalkable){
                        if ((self.nodes?[flr][row].indices.contains((current?.index.y)! + 1))!){
                            current?.neighbors["right"] = self.nodes?[flr][row][col+1]
                        }
                        if ((self.nodes?[flr][row].indices.contains((current?.index.y)! - 1))!){
                            current?.neighbors["left"] = self.nodes?[flr][row][col-1]
                        }
                        if ((self.nodes?[flr].indices.contains(((current?.index.x)! + 1)))!){
                            current?.neighbors["behind"] = self.nodes?[flr][row+1][col]
                        }
                        if ((self.nodes?[flr].indices.contains(((current?.index.x)! - 1)))!){
                            current?.neighbors["front"] = self.nodes?[flr][row-1][col]
                        }
                        //if it is a elevator then add connections to other floors
                        if (current?.value == MapNode.MapNodeValue.elevator){
                            if ((self.nodes?[flr].indices.contains((current?.index.floor)! + 1))!){
                                current?.neighbors["above"] = self.nodes?[flr+1][row][col]
                            }
                            if ((self.nodes?[flr].indices.contains((current?.index.floor)! - 1))!){
                                current?.neighbors["above"] = self.nodes?[flr-1][row][col]
                            }
                        }
                    }
                }
            }
            //corrections will be set up as floor,row,col,correct enter direction
            //1 = right, 2 = behind, 3 = left, 4 = left
            
            
            
            
            
            
            
        }
        
        
        
        
    
    }
    
    func makePath(start: Node, end: Node) throws -> Path? {
        // Make the path, and place those blue dot things on the images of the floors. Return the new image array.
        return nil
    }
    
}
