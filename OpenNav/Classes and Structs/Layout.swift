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
    
    var nodes: [[[Node]]]
    
    func makePath(start: Int, end: Int, layout: [[[Node]]], maps: [UIImage]) throws -> Path {
        // Make the path, and place those blue dot things on the images of the floors. Return the new image array.

        return 
    }
    
    func getNode(at index: Index) -> Node {
        
    }
}
