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
            // make alert to show that the layout doesn't exist
            let errorController = UIAlertController(title: "No layout found", message: "Sorry, there is no layout for the code: \"\(code)\"", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            errorController.addAction(okayAction)
            
            // make pop-up to let user know that layouts are being downloaded
            let alertController = UIAlertController(title: "Downloading Layouts", message: "This may take a couple seconds", preferredStyle: .alert)
            
            // test the code
            server.testCode(code, completion: { layoutExists in
                switch layoutExists {
                case true:
                    self.present(alertController, animated: true, completion: nil)
                    
                    self.server.getLayout(code: code, completion: { (layout) in
                        let building = BuildingInfo(layout)
                        building.saveData()
                        alertController.dismiss(animated: true, completion: nil)
                        self.dismiss()
                    })
                case false:
                    self.present(errorController, animated: true, completion: nil)
                }
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
