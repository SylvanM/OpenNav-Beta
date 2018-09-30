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

    init(_ dummy: Any) {
        numberOfFloors = 0
        acronym = ""
        name = ""

        floorImages = []
        layout = []
    }

    init() throws {
        if let amountOfFloors = UserDefaults.standard.object(forKey: "floorCount") as? Int {
            numberOfFloors = amountOfFloors
            floorImages = []

            for i in 0..<amountOfFloors {
                if let floor = UserDefaults.standard.string(forKey: ("floorImage" + String(i))) {
                    let imageData = Data(base64Encoded: floor)
                    let image = UIImage(data: imageData!)
                    self.floorImages.append(image!)

                } else { throw DataLoadingError.couldNotLoadData }
            }

            mappedImages = floorImages
        } else { throw DataLoadingError.couldNotLoadData }

        if let name = UserDefaults.standard.object(forKey: "buildingName") as? String {
            self.name = name
        } else { throw DataLoadingError.couldNotLoadData }

        if let acro = UserDefaults.standard.object(forKey: "buildingAcro") as? String {
            self.acronym = acro
        } else { throw DataLoadingError.couldNotLoadData }

    }

    func saveInfo() {
        UserDefaults.standard.set(numberOfFloors, forKey: "floorCount")
        UserDefaults.standard.set(acronym, forKey: "buildingAcro")
        UserDefaults.standard.set(name, forKey: "buildingName")
    }

    func saveLayout() {
        
    }

    func saveImages(imageCount: Int) {
        for i in 0..<imageCount {
            let imageData = floorImages[i].pngData()
            let base64String = imageData?.base64EncodedString()
            UserDefaults.standard.set(base64String, forKey: ("floorImage" + String(i)))
        }
    }

    func saveData() {
        UserDefaults.standard.set(numberOfFloors, forKey: "floorCount")
        UserDefaults.standard.set(acronym, forKey: "buildingAcro")
        UserDefaults.standard.set(name, forKey: "buildingName")

        saveImages(imageCount: numberOfFloors)

        // TODO: Save layout string array
    }
}
