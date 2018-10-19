//
//  BuildingInfo.swift
//  Navigate HoCo
//
//  Created by Sylvan Martin on 8/24/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import UIKit

/*
 * Class used to store information on the downloaded layout
 */

class BuildingInfo {
    var floorImages: [UIImage]!
    var mappedImages: [UIImage]!
    var layout: [String]!
    var imageNames: [String]!
    var info: [String : Any]!

    let keys = Keys()
    let dict = BuildingInfoDictionaryItemNames()

    // make a blank class instance
    init(_ dummy: Any) {
        info = [:]

        info[dict.floorCount] = 0
        info[dict.acronym] = ""
        info[dict.name] = ""

        floorImages = []
        layout = []
    }

    // make instance from data in UserDefaults
    init() throws {
        info = [:]

        // retrieve info dict from defaults
        if let dictData = UserDefaults.standard.data(forKey: keys.infoDict) {
            self.info = NSKeyedUnarchiver.unarchiveObject(with: dictData) as? [String : Any]
        }

        if let amountOfFloors = info[dict.floorCount] as? Int {
            info[dict.floorCount] = amountOfFloors
            floorImages = []
            self.imageNames = []

            // get image names
            for i in 0..<amountOfFloors {
                let key = (keys.imageNameBase + String(i))

                if let name = UserDefaults.standard.string(forKey: key) {
                    self.imageNames.append(name)
                } else {
                    throw DataLoadingError.couldNotLoadData
                }
            }

            print("Names: \(String(describing: self.imageNames))")

            // get saved images
            for i in 0..<amountOfFloors {
                if let floor = UserDefaults.standard.string(forKey: (keys.imageBase + String(i))) {
                    // retrieve and decode base64 encoded image data
                    let imageData = Data(base64Encoded: floor)
                    let image = UIImage(data: imageData!)
                    self.floorImages.append(image!)

                } else { throw DataLoadingError.couldNotLoadData }
            }

            // these should be the same until the user makes a route
            mappedImages = floorImages
        } else {
            print("Failed to load amount of floors")
            throw DataLoadingError.couldNotLoadData
        }
    }

    // save info dictionary to UserDefaults
    func saveInfo() {
        let defaults = UserDefaults.standard
        do {
            let infoDictData = try NSKeyedArchiver.archivedData(withRootObject: self.info, requiringSecureCoding: true)
            defaults.set(infoDictData, forKey: keys.infoDict)
        } catch {
            print("Error on saving info dictionary: \(error)")
        }

        for i in 0..<imageNames.count {
            defaults.set(imageNames[i], forKey: (keys.imageNameBase + String(i)))
        }
    }

    // encode images to base64 data and save to UserDefaults
    func saveImages(imageCount: Int) {
        for i in 0..<imageCount {
            let imageData = floorImages[i].pngData()
            let base64String = imageData?.base64EncodedString()
            UserDefaults.standard.set(base64String, forKey: (keys.imageBase + String(i)))
        }
    }

    // save ALL data stored in this class to userDefaults
    func saveData() {
        clearLayoutData()

        saveInfo()
        saveImages(imageCount: info![dict.floorCount] as! Int)

        UserDefaults.standard.synchronize()
        // TODO: Save layout string array
    }
}
