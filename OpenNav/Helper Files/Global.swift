//
//  Global Constants.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/3/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

// MARK: CONSTANTS
struct Keys {
    public let buildingName = "buildingName"
    public let imageCount = "floorCount"
    public let imageNameBase = "imageName"
    public let imageBase = "floorImage"
    public let acronym = "buildingAcro"
    public let infoDict = "layoutInformationDictionary"
    public let layoutCode = "codeInputText"
}

struct BuildingInfoDictionaryItemNames {
    public let floorCount = "Images Available"
    public let acronym = "Acronym"
    public let name = "Name"
}

// MARK: FUNCTIONS
func clearUserDefaults() {
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()

    print("Cleared UserDefaults")
}
