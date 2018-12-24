//
//  MapView+Route.swift
//  OpenNav
//
//  Created by Sylvan Martin on 11/11/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController {
    
    func promptForRoute() {
        let dict = BuildingInfoDictionaryItemNames()
        
        if let layout = building.layout {
            let alertController = UIAlertController(title: "Choose Path", message: "Choose a start room and end location", preferredStyle: .alert)
            
            let goHandler: ((UIAlertAction) -> Void)? = { _ in
                // this code will execute when the user presses go
                print("routable!")
            }
            
            let goAction = UIAlertAction(title: "Go", style: .default, handler: goHandler)
            alertController.addAction(goAction)
            
            self.present(alertController, animated: true)
        } else {
            displayErrorMessage(NavigationError.layoutNotRoutable)
        }
    }
    
}
