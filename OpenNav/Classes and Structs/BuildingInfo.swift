//
//  BuildingInfo.swift
//  Navigate HoCo
//
//  Created by Sylvan Martin on 8/24/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

/*
 * Class used to store information on the downloaded layout
 */

class BuildingInfo {
    var floorImages: [String : UIImage]?
    var mappedImages: [String : UIImage]?
    var stringLayout: [[[String]]]?
    var info: [String : Any]?
    var layout: Layout?
    
    // used to retrieve data from files
    var retrievalDict: [String : String]?
    
    let keys = Keys()
    let dict = BuildingInfoDictionaryItemNames()

    // make a blank class instance
    
    init(_ jsonDictionary: [String : JSON?]) {
        
        print("JSON: ", jsonDictionary)
        
        // set up layout
        if let layoutJson = jsonDictionary["layout"] {
            let stringLayout = layoutJson?.arrayObject as? [[[String]]]
            self.stringLayout = stringLayout
            
            self.layout = Layout(stringLayout!)
        }
        
        // set up images
        if let imageJson = jsonDictionary["images"] {
            if let images = imageJson?.dictionaryObject as? [String : String] {
                for (name, encodedImage) in images {
                    let decodedData = Data(base64Encoded: encodedImage)
                    let image = UIImage(data: decodedData!)
                    self.floorImages?[name] = image
                }
                self.mappedImages = floorImages
            }
        }
        
        if let infoJson = jsonDictionary["info"] {
            self.info = infoJson?.dictionaryObject
        }
    }

    // make instance from data in UserDefaults
    init() throws {
        let path = getDocumentsDirectory().appendingPathComponent("layout.plist")
        let nsdict = NSDictionary(contentsOf: path)
        
        if let dict = nsdict as? [String : Any] {
            // convert dict to [String : JSON]
            let json: [String : JSON] = [
                "images": JSON(dict["images"] as Any),
                "info": JSON(dict["info"]!),
                "layout": JSON(dict["layout"]!)
            ]
            
            let recoveredObject = BuildingInfo(json)
        
            self.floorImages = recoveredObject.floorImages
            self.mappedImages = recoveredObject.mappedImages
            self.layout = recoveredObject.layout
            self.info = recoveredObject.info
        } else {
            throw DataLoadingError.couldNotLoadData
        }
    }

    // save ALL data stored in this class to userDefaults
    func saveData() {
        print("Saving layout...")
        
        var allLayoutDict: [String : Any] = [
            "info": self.info as Any,
            "layout": self.layout as Any
        ]
        
        if let images = self.floorImages {
            allLayoutDict["images"] = images
        }
        
        print("General layout: ", allLayoutDict)
        
        let dictionary = NSDictionary(dictionary: allLayoutDict)
        print("Converted dictionary: ", dictionary)
        
        let filename = getDocumentsDirectory().appendingPathComponent("layout.plist")
        print("Saving to file: ", filename)
        do {
            try dictionary.write(to: filename)
            print("Saved!")
        } catch {
            print("ERROR on saving layout: ", error)
        }
        
    }
}
