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
        self.floorImages = []
        // retrieve info dict from defaults
        let infoDictFileName = "layoutInfo.plist"
        let filePath = getDocumentsDirectory().appendingPathComponent(infoDictFileName)
        
        let dictData = NSDictionary(contentsOf: filePath)
        self.info = (dictData as Any) as? [String : Any]
        
        if let layoutData = info[dict.layoutData] as? [String : Any], let floorCount = layoutData[dict.floorCount] as? Int {
            for i in 0..<floorCount {
                let imageFileName = "image\(i).png"
                
                // retrieve and decode base64 encoded image data
                let imageURL = getDocumentsDirectory().appendingPathComponent(imageFileName)
                
                do {
                    let imageData = try Data(contentsOf: imageURL)
                    let image = UIImage(data: imageData)
                    self.floorImages.append(image!)
                } catch {
                    print("Could not load images")
                    throw DataLoadingError.couldNotLoadData
                }
            }
            
            // these should be the same until the user makes a route
            mappedImages = floorImages
        } else {
            print("layout dict not loaded")
            throw DataLoadingError.couldNotLoadData
        }
    }

    // save info dictionary to UserDefaults
    func saveInfo() {
        let fileName = "layoutInfo.plist"
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        
        let dict = NSDictionary(dictionary: self.info!)
        
        do {
            try dict.write(to: filePath)
        } catch {
            print("Error on saving info dictionary: \(error)")
        }
    }

    // encode images to base64 data and save to UserDefaults
    func saveImages(imageCount: Int) {
        for i in 0..<imageCount {
            let imageData = floorImages[i].pngData()
        
            let imageName = "image\(i).png"
            
            let filename = getDocumentsDirectory().appendingPathComponent(imageName)
            
            do {
                try imageData?.write(to: filename)
            } catch {
                print(error)
            }
        }
    }

    // save ALL data stored in this class to userDefaults
    func saveData() {
        clearLayoutData()

        saveInfo()
        let layoutData = info[dict.layoutData] as! [String : Any]
        let imageCount = layoutData[dict.floorCount] as! Int
        saveImages(imageCount: imageCount)

        UserDefaults.standard.synchronize()
        // TODO: Save layout string array
    }
}
