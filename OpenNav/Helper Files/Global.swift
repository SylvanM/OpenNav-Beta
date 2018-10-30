//
//  Global Constants.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/3/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

/*
 * This file us just to house all global constants
 */

// MARK: CONSTANTS
struct Keys {
    public let buildingName = "buildingName"
    public let imageCount = "floorCount"
    public let imageNameBase = "imageName"
    public let imageBase = "floorImage"
    public let acronym = "buildingAcro"
    public let infoDict = "layoutInformationDictionary"
    public let layoutCode = "codeInputText"
    
    public let darkMode = "darkMode"
    public let tint = "appTint"
}

let navdataserviceURL = "https://navdataservice.000webhostapp.com/layouts/"
let testURL = "http://opennav-webservice.azurewebsites.net/"

struct BuildingInfoDictionaryItemNames {
    
    public let layoutData = "layoutData"
    
    public let floorCount = "floorCount"
    public let acronym = "acronym"
    public let imageNames = "imageNames"
    
    
    public let presentableInfo = "presentableInfo"
    
    public let imagesAvailable = "Images Available"
    public let name = "Name"
}

// MARK: FUNCTIONS
func clearLayoutData() {
    let keys = Keys()
    
    var layoutCode: String? {
        guard let code = UserDefaults.standard.object(forKey: keys.layoutCode) as? String else {
            return nil
        }
        
        return code
    }
    
    // clear all items in UserDefaults
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
    
    // save persisted data
    UserDefaults.standard.set(layoutCode, forKey: keys.layoutCode)

    print("Cleared Layout Data")
}
