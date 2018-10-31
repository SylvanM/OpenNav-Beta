//
//  MapView+Refresh.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/30/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController {
    
    func refresh() {
        
        // dark mode
        switch UserDefaults.standard.bool(forKey: keys.darkMode) {
        case true:
            enableDarkMode()
        case false:
            disableDarkMode()
        }
        
        do {
            
            // make spinning activity indicator in top left of view in place of info button
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            let barButton = UIBarButtonItem(customView: activityIndicator)
            self.navigationItem.setLeftBarButton(barButton, animated: true)
            activityIndicator.startAnimating()
            
            // make new building from UserDefaults
            building = try BuildingInfo()
            
            // put title at top of view with the acronym of the layout
            if let layoutData = building.info[dict.layoutData] as? [String : Any], let acro = layoutData[dict.acronym] as? String {
                self.navigationItem.title = acro + " Map"
            } else {
                print("Could not load acronym")
                self.navigationItem.title = "Map"
            }
            
            switch viewType {
            case .normal: // if normal view type, display regular images
                //                mapImageView.image = building.floorImages.first
                mapImageView.image = building.floorImages[selectedImage] // This line can result in crash sometimes
                // When the previous layout has less images and the layout switches,
                // if the selected image was of a higher index than the highest of the current layout,
            // we will get the "Index out of range" error and then crash
            case .route: // if map view type, display nmarked images
                //                mapImageView.image = building.mappedImages.first
                mapImageView.image = building.mappedImages[selectedImage] // This line can result in crash sometimes <#same reason as above#>
            }
            
            activityIndicator.stopAnimating()
            
            self.navigationItem.setLeftBarButton(infoButton, animated: true) // set left bar button item back to info button
        } catch {
            displayErrorMessage(error)
            print("Unknown error")
        }
    }
    
    
}
