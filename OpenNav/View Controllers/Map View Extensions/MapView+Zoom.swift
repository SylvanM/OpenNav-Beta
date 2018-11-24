//
//  MapView+Zoom.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/30/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController {
   
    // Allow user to zoom into view in Map View
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mapImageView
    }
    
}
