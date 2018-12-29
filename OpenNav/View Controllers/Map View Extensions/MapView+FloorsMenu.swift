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
        
        if let images = building.floorImages {
            
            for (name, _) in images {
                let viewFloorAction = UIAlertAction(title: name, style: .default, handler: { (_) in
                    self.selectedImage = name
                    print("Trying to view image \(name)")
                    self.refresh()
                })
                
                alertController.addAction(viewFloorAction)
            }
        }
        
        // make an action/button to let the user dismiss the "route" image overlay
        let clearRouteAction = UIAlertAction(title: "Clear", style: .default, handler: { (_) in
            self.viewType = .normal
            self.refresh()
        })
        
        // prepare alert
        let cancelAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        
        alertController.addAction(clearRouteAction)
        alertController.addAction(cancelAction)
        
        // present the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
