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
        switch settings.get(setting: .darkMode) as! Bool {
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
            if let info = building.info {
                if let acro = info[dict.acronym] as? String {
                    self.navigationItem.title = acro + " Map"
                } else {
                    print("Could not load acronym")
                    self.navigationItem.title = "Map"
                }
            }
            
            switch viewType {
            case .normal: // if normal view type, display regular images
                //                mapImageView.image = building.floorImages.first
                if let selected = selectedImage {
                    mapImageView.image = building.floorImages?[selected]
                } else {
                    mapImageView.image = building.floorImages?.first?.value
                }
            case .route: // if map view type, display nmarked images
                //                mapImageView.image = building.mappedImages.first
                if let selected = selectedImage {
                    mapImageView.image = building.mappedImages?[selected]
                } else {
                    mapImageView.image = building.mappedImages?.first?.value
                }
            }
            
            activityIndicator.stopAnimating()
            
            self.navigationItem.setLeftBarButton(infoButton, animated: true) // set left bar button item back to info button
        } catch {
            displayErrorMessage(error)
            print("Error on loading view")
        }
    }
    
    
}
