//
//  BuildingInfo.swift
//  Navigate HoCo
//
//  Created by Sylvan Martin on 8/24/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import UIKit

class BuildingInfo {
    var numberOfFloors: Int!
    var acronym: String!
    var name: String!
    var floorImages: [UIImage]!
    var mappedImages: [UIImage]!
    var layout: [String]!
    var imageNames: [String]!

    let keys = Keys()

    init(_ dummy: Any) {
        numberOfFloors = 0
        acronym = ""
        name = ""

        floorImages = []
        layout = []
    }

    init() throws {
        if let amountOfFloors = UserDefaults.standard.object(forKey: keys.imageCount) as? Int {
            numberOfFloors = amountOfFloors
            floorImages = []
            self.imageNames = []

            for i in 0..<amountOfFloors {
                let key = (keys.imageNameBase + String(i))

                if let name = UserDefaults.standard.string(forKey: key) {
                    self.imageNames.append(name)
                } else {
                    throw DataLoadingError.couldNotLoadData
                }
            }

            print("Names: \(String(describing: self.imageNames))")

            for i in 0..<amountOfFloors {
                if let floor = UserDefaults.standard.string(forKey: (keys.imageBase + String(i))) {
                    let imageData = Data(base64Encoded: floor)
                    let image = UIImage(data: imageData!)
                    self.floorImages.append(image!)

                } else { throw DataLoadingError.couldNotLoadData }
            }

            mappedImages = floorImages
        } else { throw DataLoadingError.couldNotLoadData }

        if let name = UserDefaults.standard.object(forKey: keys.buildingName) as? String {
            self.name = name
        } else { throw DataLoadingError.couldNotLoadData }

        if let acro = UserDefaults.standard.object(forKey: keys.acronym) as? String {
            self.acronym = acro
        } else { throw DataLoadingError.couldNotLoadData }
    }

    func saveInfo() {
        let defaults = UserDefaults.standard

        defaults.set(numberOfFloors, forKey: keys.imageCount)
        defaults.set(acronym, forKey: keys.acronym)
        defaults.set(name, forKey: keys.buildingName)

        for i in 0..<imageNames.count {
            defaults.set(imageNames[i], forKey: (keys.imageNameBase + String(i)))
        }
    }

    func saveImages(imageCount: Int) {
        for i in 0..<imageCount {
            let imageData = floorImages[i].pngData()
            let base64String = imageData?.base64EncodedString()
            UserDefaults.standard.set(base64String, forKey: (keys.imageBase + String(i)))
        }
    }

    func saveData() {
        saveInfo()
        saveImages(imageCount: numberOfFloors)

        // TODO: Save layout string array
    }
}
