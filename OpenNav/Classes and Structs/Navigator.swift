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

class Navigator {
    func makePath(start: Int, end: Int, layout: [String], maps: [UIImage]) throws -> [UIImage] {
        let markedImages = [UIImage]()

        // Make the path, and place those blue dot things on the images of the floors. Return the new image array.

        return markedImages
    }
}
