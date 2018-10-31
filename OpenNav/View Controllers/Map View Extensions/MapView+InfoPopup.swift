//
//  MapView+InfoPopup.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/30/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController {
    func displayInfo() {
        var message: String = ""
        
        // make a new line for each piece of info in info dictionary, add it to "message" string
        let layoutData = building.info[dict.presentableInfo] as! [String : Any]
        for (key, _) in layoutData {
            message += "\(key): \(layoutData[key]!)\n"
        }
        
        // make popup to display message string
        let presentableInfo = building.info[dict.presentableInfo] as! [String : Any]
        let alertController = UIAlertController(title: (presentableInfo[dict.name] as! String), message: message, preferredStyle: .alert)
        
        // present pop-up, listen for user to tap backgroumnd. When user does, dismiss pop up.
        self.present(alertController, animated: true, completion: {
            alertController.view.superview?.isUserInteractionEnabled = true
            alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.userTappedBackground)))
        })
    }
}
