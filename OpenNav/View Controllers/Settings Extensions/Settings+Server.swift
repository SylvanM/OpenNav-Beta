//
//  Settings+Server.swift
//  OpenNav
//
//  Created by Sylvan Martin on 11/10/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import UIKit

extension SettingsViewController {
    
    func getLayouts(code: String) {
        do {
            // make pop-up to let user know that layouts are being downloaded
            let alertController = UIAlertController(title: "Downloading Layouts", message: "This may take a couple seconds", preferredStyle: .alert)
            
            self.present(alertController, animated: true, completion: nil)
            
            // make instance of SchoolInfo with all blank data, this is what we will save to UserDefaults later
            // this is like making an empty string and adding stuff to it later on, then returning the final string
            let building = BuildingInfo("dummy")
            
            server.getBuildingData(for: code, completion: { (images, imageNames, infoDictionary) in
                
                // assign items in info dictionary to items from downloaded JSON
                let presentableInfo = infoDictionary.dictionaryObject
                
                let layoutData: [String : Any] = [
                    self.dict.floorCount: images.count,
                    self.dict.imageNames: imageNames
                ]
                
                building.info = [
                    self.dict.presentableInfo: presentableInfo as Any,
                    self.dict.layoutData: layoutData as Any
                ]
                
                // save images to building instance
                building.floorImages = images
                building.saveData() // save the building to userdefaults to be used by other classes (primarily the Map View)
                
                alertController.dismiss(animated: true, completion: nil)
                
                _ = self.navigationController?.popViewController(animated: true) // jump back to root view controller
            })
            
        }
        // No errors are actuall thrown in the "do" block, so there isn't any point for this catch block
        // Not gonna delete this block because it may come in handy later
        //            catch {
        //                let ac = UIAlertController(title: "Unable to retrieve building data", message: "Please double check the code you entered", preferredStyle: .alert)
        //                let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        //                ac.addAction(confirmAction)
        //
        //                present(ac, animated: true, completion: nil)
        //            }
    }
    
}
