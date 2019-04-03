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
    var rooms: [String : Index]?
    var layout: Layout?
    
    // used to retrieve data from files
    var retrievalDict: [String : String]?
    
    let keys = Keys()
    let dict = BuildingInfoDictionaryItemNames()

    // make a blank class instance
    
    init(_ jsonDictionary: [String : JSON?]) {
        
        if let temp = jsonDictionary["rooms"], let rooms = temp?.dictionaryObject as? [String : [Int]] {
            // room dict exists
            self.rooms = [:]

            // create an index for each json array in rooms
            for (name, array) in rooms {
                // 1d string array containing the info for making an index for one room
                var roomInfoArray: [Int] = []
                roomInfoArray = array.map { $0 }
                // create index from roomInfoArray
                let index = Index(floor: roomInfoArray[0], x: roomInfoArray[1], y: roomInfoArray[2])

                self.rooms?[name] = index
            }
        } else {
            print("No rooms")
        }
        
        // set up layout
        if let layoutJson = jsonDictionary["layout"], let layout = layoutJson?.arrayObject as? [[[String]]] {
            self.layout = Layout(layout, correction: [])
            self.stringLayout = layout
        } else {
            print("No layout")
        }
        
        // set up images
        if let temp = jsonDictionary["images"], let imageJson = temp {
            self.floorImages = [:]
            if let images = imageJson.dictionaryObject as? [String : String] {
                for (name, encodedImage) in images {
                    let imageData = Data(base64Encoded: encodedImage)!
                    let image = UIImage(data: imageData)!
                    self.floorImages?[name] = image
                }
                self.mappedImages = floorImages
            }
        } else {
            print("No images")
        }
        
        if let temp = jsonDictionary["info"], let infoJson = temp {
            self.info = infoJson.dictionaryObject
        } else {
            print("No info")
        }
    }

    // make instance from data in UserDefaults
    init() throws {
        
        let url = getDocumentsDirectory().appendingPathComponent("layout")
        
        do {
            let recoveredData = try Data(contentsOf: url)
            let recoveredString = String(data: recoveredData, encoding: .utf8)!
            let recoveredJson   = JSON(parseJSON: recoveredString)
//            print("Recovered Json: ", recoveredJson)
            
            var jsonDict = recoveredJson.dictionary!
            let layout = jsonDict["layout"]
            jsonDict["layout"] = layout?.arrayValue.first!
            let loadedLayout = BuildingInfo(jsonDict)

            // set all self values
            self.floorImages = loadedLayout.floorImages
            self.mappedImages = loadedLayout.mappedImages
            self.stringLayout = loadedLayout.stringLayout
            self.layout = loadedLayout.layout
            self.info = loadedLayout.info
            self.rooms = loadedLayout.rooms
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
        } else {
            print("No images stored lol")
        }
        
        // convert layout
        if let layout = self.stringLayout {
            let jsonArray = JSON(arrayLiteral: layout)
            dictionary["layout"] = jsonArray
        }
        
        // convert rooms
        if let rooms = self.rooms {
            var roomJson: JSON = JSON()
            
            for (name, index) in rooms {
                let roomInfoArray = [index.floor, index.x, index.y]
                let roomInfoJson  = JSON(roomInfoArray)
                roomJson[name]    = roomInfoJson
            }
            
            dictionary["rooms"] = roomJson
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
