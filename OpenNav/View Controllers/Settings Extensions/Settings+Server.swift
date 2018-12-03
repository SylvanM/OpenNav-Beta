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
            
            server.getBuildingData(for: code, completion: { (images, infoDictionary) in
                let building = BuildingInfo(images: images, info: infoDictionary)
                
                building.saveData() // save the building to userdefaults to be used by other classes (primarily the Map View)
                
                print("Building info: ", building.info)
                
                alertController.dismiss(animated: true)
                
                self.dismiss()
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
    
    func dismiss() {
        _ = self.navigationController?.popViewController(animated: true) // jump back to root view controller
    }
    
}
