//
//  MapView+Routing.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/30/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController {
    
    func displayRoutePopup() {
        let routePrompt = UIAlertController(title: "Make path", message: "Choose your start and destination", preferredStyle: .alert)
        
        routePrompt.addTextField { (textField) in textField.placeholder = "Start"; textField.keyboardType = UIKeyboardType.numberPad }
        routePrompt.addTextField { (textField) in textField.placeholder = "Destination"; textField.keyboardType = UIKeyboardType.numberPad }
        
        // function for "route" button to take in the room numbers and overlay a path
        let confirmAction = UIAlertAction(title: "Go", style: .default, handler: { (_) in
            if let start = Int(routePrompt.textFields![0].text!), let destination = Int(routePrompt.textFields![1].text!) {
                let navigator = Navigator() // make instance of Navigator class to do the work for us
                do {
                    // pass in current images and layout of the building to the navigator class
                    let layout = self.building.layout!
                    let maps = self.building.floorImages!
                    
                    // get back 'marked' images from makePath() function
                    self.building.mappedImages = try navigator.makePath(start: start, end: destination, layout: layout, maps: maps)
                    self.viewType = .route
                    self.refresh()
                } catch {
                    self.displayErrorMessage(error)
                }
            }
        })
        
        // canel
        let cancelAction = UIAlertAction(title: "nvm", style: .default, handler: nil)
        
        routePrompt.addAction(confirmAction)
        routePrompt.addAction(cancelAction)
        
        // show popup
        self.present(routePrompt, animated: true, completion: nil)
    }
    
    
}
