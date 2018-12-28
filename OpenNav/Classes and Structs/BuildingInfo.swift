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
        
        // set up layout
        if let layoutJson = jsonDictionary["layout"] {
            
            var stringArray: [[[String]]] = [[[]]]
            let layout = layoutJson?.arrayValue.first!
            for i in 0...layout!.count {
                print("Layout: ", layout)
                let floor = layoutJson?.arrayValue[i]
                var floorStringValues: [[String]] = [[]]
                
                for j in 0..<floor!.count {
                    let row = floor!.arrayValue[j]
                    let rowStringValues = row.arrayValue.map { $0.stringValue }
                    
                    floorStringValues.append(rowStringValues)
                }
                floorStringValues.removeFirst()
                stringArray.append(floorStringValues)
            }
        
            stringArray.removeFirst()
            print("String array: ", stringArray)
            
            self.stringLayout = stringArray
            self.layout = Layout(stringArray)
        }
        
        // set up images
        if let imageJson = jsonDictionary["images"] {
            print("image json exists")
            if let images = imageJson?.dictionaryObject as? [String : String] {
                print("Images are converted")
                for (name, encodedImage) in images {
                    let decodedData = Data(base64Encoded: encodedImage)
                    let image = UIImage(data: decodedData!)
                    self.floorImages?[name] = image
                    print("images are decoded")
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
        let url = getDocumentsDirectory().appendingPathComponent("layout")
        do {
            let recoveredData = try Data(contentsOf: url)
            let recoveredString = String(data: recoveredData, encoding: .utf8)!
            let recoveredJson   = JSON(parseJSON: recoveredString)
            let loadedLayout = BuildingInfo(recoveredJson.dictionary!)

            // set all self values
            self.floorImages = loadedLayout.floorImages
            self.mappedImages = loadedLayout.mappedImages
            self.stringLayout = loadedLayout.stringLayout
            self.layout = loadedLayout.layout
            self.info = loadedLayout.info
        } catch {
            print("error on loading data: ", error)
            throw DataLoadingError.couldNotLoadData
        }
        
    }

    // save ALL data stored in this class to userDefaults
    func saveData() {
        var dictionary: [String : JSON] = [:]
        
        // convert each part of the layout to a JSON object to be saved
        
        // convert info
        if let info = self.info {
            let imageJson = JSON(info)
            dictionary["info"] = imageJson
        }
        
        // convert images
        if let images = self.floorImages {
            var encodedDict: [String : String] = [:]
            for (name, image) in images {
                let imageData = image.pngData()
                let encodedData = imageData?.base64EncodedString()
                encodedDict[name] = encodedData
            }
            dictionary["images"] = JSON(encodedDict)
        }
        
        // convert layout
        if let layout = self.layout {
            let jsonArray = JSON(arrayLiteral: self.stringLayout!)
            dictionary["layout"] = jsonArray
        }
        
        // save it
        let file       = getDocumentsDirectory().appendingPathComponent("layout")
        let fullJson   = JSON(dictionary)
        let jsonString = fullJson.description
        let stringData = jsonString.data(using: .utf8)
        do {
            try stringData?.write(to: file)
            print("Saved layout!")
        } catch {
            print("Data saving error: ", error)
        }
    }
}
