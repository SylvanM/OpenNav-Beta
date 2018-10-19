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
    
    public let applicationID = "applicationID"
}

struct BuildingInfoDictionaryItemNames {
    public let floorCount = "Images Available"
    public let acronym = "Acronym"
    public let name = "Name"
}

// MARK: FUNCTIONS
func clearLayoutData() {
    let keys = Keys()
    
    // save items in UserDefaults that we DON'T want to get rid of
    var appID: String? {
        if let string = UserDefaults.standard.object(forKey: keys.applicationID) as? String {
            return string
        } else {
            return nil
        }
    }
    var layoutCode: String? {
        if let code = UserDefaults.standard.object(forKey: keys.layoutCode) as? String {
            return code
        } else {
            return nil
        }
    }
    
    // clear all items in UserDefaults
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
    
    // save persisted data
    UserDefaults.standard.set(appID, forKey: keys.applicationID)
    UserDefaults.standard.set(layoutCode, forKey: keys.layoutCode)

    print("Cleared Layout Data")
}
