//
//  MapView+ErrorMessage.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/30/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController {
    
    // displays an error message with an error as input. This will be a popup for the user.
    func displayErrorMessage(_ error: Error = DataLoadingError.couldNotLoadData) {
        var alertController = UIAlertController(title: "Something went wrong", message: "Not sure what.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        
        var title: String!
        var message: String!
        
        switch error {
        case DataLoadingError.couldNotLoadData: // display 'could not load data' error in popup
            title = "Map not available"
            message = "Please set up a map in settings"
        case NavigationError.noSuchRoomInBuilding: // display 'no such room' error in popup
            title = "No such room"
            message = "Please choose a start and destination that actually exist"
        case NavigationError.layoutNotRoutable:
            title = "Layout not routable"
            message = "This layout cannot find you the fastest path"
        default: // display misc error in popup
            title = "Something went wrong"
            message = "And we have no idea what that something is"
        }
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
        print(error)
    }
    
    
}
