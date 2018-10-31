//
//  MapView+FloorsMenu.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/30/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController {
    
    func displayFloorsMenu() {
        let alertController = UIAlertController(title: "Which Floor?", message: "Choose the floor to view", preferredStyle: .actionSheet)
        
        // for ever image available, create a button and corresponding action for the user to press
        let layoutData = self.building.info[dict.layoutData] as? [String : Any]
        for i in 0..<(layoutData![dict.floorCount] as! Int) {
            let imageNames = layoutData![dict.imageNames] as! [String]
            let viewFloorAction = UIAlertAction(title: imageNames[i], style: .default, handler: { (_) in
                self.selectedImage = i
                print("Trying to view image \(i)")
                self.refresh()
            })
            
            alertController.addAction(viewFloorAction)
        }
        
        // make an action/button to let the user dismiss the "route" image overlay
        let clearRouteAction = UIAlertAction(title: "Clear", style: .default, handler: { (_) in
            self.viewType = .normal
            self.refresh()
        })
        
        // self explanatory
        let cancelAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        
        alertController.addAction(clearRouteAction)
        alertController.addAction(cancelAction)
        
        // present the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
