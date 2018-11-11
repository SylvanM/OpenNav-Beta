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
        
        if let info = building.info[dict.presentableInfo] as? [String : Any], let navMatrix = info[dict.navMatrix], let correctionMatrix = info[dict.correctionMatrix] {
            let alertController = UIAlertController(title: "Choose Path", message: "Choose a start room and end location", preferredStyle: .alert)
            
            let goHandler: ((UIAlertAction) -> Void)? = { _ in
                // this code will execute when the user presses go
            }
            
            let goAction = UIAlertAction(title: "Go", style: .default, handler: goHandler)
            alertController.addAction(goAction)
        } else {
            displayErrorMessage(NavigationError.layoutNotRoutable)
        }
    }
    
}
