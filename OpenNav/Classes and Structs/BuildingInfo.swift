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

            for i in 0...(amountOfFloors - 1) {
                if let floor = UserDefaults.standard.data(forKey: ("floorImage" + String(i))) {
                    let image = UIImage(data: floor)
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

    func saveImages(imageCount: Int) {
        for i in 0...(imageCount - 1) {
            UserDefaults.standard.set(floorImages[i].pngData(), forKey: ("floorImage" + String(i)))
        }
    }

    func saveData() {
        UserDefaults.standard.set(numberOfFloors, forKey: "floorCount")
        UserDefaults.standard.set(acronym, forKey: "buildingAcro")
        UserDefaults.standard.set(name, forKey: "buildingName")

        for i in 0...(numberOfFloors - 1) {
            UserDefaults.standard.set(floorImages[i].pngData(), forKey: ("floorImage" + String(i)))
        }

        // TODO: Save layout string array
    }
}
