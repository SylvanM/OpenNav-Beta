//
//  String+Node.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/28/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

typealias MapNodeIndex = Index

extension String {
    
    func toNode(_ index: MapNodeIndex) -> MapNode {
        return MapNode(string: self, index: index)
    }
    
}
