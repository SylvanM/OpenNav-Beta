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
        switch error {
        case DataLoadingError.couldNotLoadData: // display 'could not load data' error in popup
            let alertController = UIAlertController(title: "No map available", message: "Please make sure you have configured your building info in Settings", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            
            present(alertController, animated: true, completion: nil)
            
            print(error)
        case NavigationError.noSuchRoomInBuilding: // display 'no such room' error in popup
            let alertController = UIAlertController(title: "No such room", message: "Make sure the start and destination are rooms within the building!", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            
            present(alertController, animated: true, completion: nil)
            
            print(error)
        default: // display misc error in popup
            let alertController = UIAlertController(title: "Something went wrong :P", message: "That's out fault. Sorry.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            
            present(alertController, animated: true, completion: nil)
            
            print(error)
        }
    }
    
    
}
