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
    init(_ blank: Any) {
        info = [:]

        info[dict.floorCount] = 0
        info[dict.acronym] = ""
        info[dict.name] = ""

        floorImages = []
        layout = []
    }
    
    // make dummy instance with preloaded data
    init(images: [UIImage], info: [String : Any]) {
        self.floorImages = images
        self.info = info
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
        
        if let object = info, let floors = object[dict.floorCount], let floorCount = floors as? Int {
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
    func saveImages() {
        for i in 0..<floorImages.count {
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
        saveInfo()
        print("Saving data --")
        print(info)
        saveImages()
    }
}
