//
//  ServerCommunicator.swift
//  Navigate HoCo
//
//  Created by Sylvan Martin on 8/22/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ServerCommunicator {

    var key : [UInt8]!
    var iv  : [UInt8]!

    enum ServerError: Error {
        case code404
    }

    func getDecryptionInfo(forCode: String, completion: @escaping ([UInt8], [UInt8]) -> ()) {
        let request = BuildingInfoRequest(code: forCode, fileName: "encryption.json")

        if verifyURL(urlString: request.url) {
            Alamofire.request(request.url).responseJSON { (response) in
                let json = JSON(response.result.value!)

                let keyBytes = json["key"].stringValue.bytes
                let ivBytes = json["iv"].stringValue.bytes

                completion(keyBytes, ivBytes)
            }
        }
    }

    func getBuildingData(for code: String, completion: @escaping ([UIImage], [String], JSON) -> ()) {
        let request = BuildingInfoRequest(code: code, fileName: "data.json")


        if verifyURL(urlString: request.url) {
//            let group = DispatchGroup()
//            group.enter()

            getDecryptionInfo(forCode: code, completion: { (keyBytes, ivBytes) in
                self.key = keyBytes
                self.iv = ivBytes

                Alamofire.request(request.url).responseData { (response) in
                    if response.error != nil {
                        // Handle error
                    } else {
                        do {
                            
                            
                            
                            let keyData = Data(bytes: self.key)
                            let ivData = Data(bytes: self.iv)
                            
                            let dataFromServer = response.data!
                            let decryptedData = try dataFromServer.decrypt(key: keyData, iv: ivData)

                            let jsonData = try JSON(data: decryptedData)

                            // get basic info
                            let floorCount = jsonData["floors"].count

                            let info = jsonData["info"]

                            // get image names
                            var reversedImageNames: [String] = []
                            // get images
                            var images: [UIImage] = []
                            
                            var collectedFloorCount: Int! {
                                didSet {
                                    if collectedFloorCount == floorCount {
                                        let imageNames: [String] = reversedImageNames.reversed()
                                        completion(images, imageNames, info)
                                    }
                                }
                            }
                            
                            for floorName in jsonData["floors"] {
                                reversedImageNames.append(floorName.0)
                                
                                self.getImage(code: code, name: floorName.0) { image in
                                    images.append(image)
                                    collectedFloorCount += 1
                                }
                            }
   
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                }
            })
        }
    }
    
    func getImage(code: String, name: String, completion: @escaping (UIImage) -> ()) {
        let urlString = navdataserviceURL + code + "/" + name
        let url = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        Alamofire.request(url).responseData() { response in
            let data = response.data!
            let image = UIImage(data: data)!
            
            completion(image)
        }
    }
    
    func verifyURL(urlString: String) -> Bool {
        return true
    }

    struct BuildingInfoRequest {
        let baseURL: String = navdataserviceURL

        var code: String
        var desiredFileName: String!

        var urlString: String
        var url: String

        init(code: String, fileName: String) {
            self.code = code
            self.desiredFileName = fileName

            urlString = baseURL + code + "/" + fileName

            url = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        }
    }
}
