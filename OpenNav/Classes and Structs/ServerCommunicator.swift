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
            print("Making Request: \(request.url)")
            Alamofire.request(request.url).responseJSON { (response) in
                print("Request completed: \(request.url)")
                print("Making JSON ->")
                let json = JSON(response.result.value!)
                print(" -> JSON successfully created")

                let keyBytes = json["key"].stringValue.bytes
                let ivBytes = json["iv"].stringValue.bytes

                print("Key: \(json["key"].stringValue)")
                print("IV: \(json["iv"].stringValue)")

                completion(keyBytes, ivBytes)
            }
        }
    }

    func getBuildingData(forCode: String, completion: @escaping ([UIImage], [String], JSON) -> ()) {
        let request = BuildingInfoRequest(code: forCode, fileName: "data.json")


        if verifyURL(urlString: request.url) {
            let group = DispatchGroup()
            group.enter()

            getDecryptionInfo(forCode: forCode, completion: { (keyBytes, ivBytes) in
                self.key = keyBytes
                self.iv = ivBytes

                print("Making Request: \(request.url)")
                Alamofire.request(request.url).responseData { (response) in
                    print("Request completed: \(request.url)")
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

                            for (key, _) in jsonData["floors"] {
                                reversedImageNames.append(key)
                            }

                            let imageNames: [String] = reversedImageNames.reversed()
                            
                            // get images
                            var images: [UIImage] = []

                            for floor in 0..<floorCount {
                                let base64StringForImage = jsonData["floors"][imageNames[floor]].stringValue
                                let dataFromEncodedString = Data(base64Encoded: base64StringForImage, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
                                
                                let imageFromDecodedData = UIImage(data: dataFromEncodedString)!

                                images.append(imageFromDecodedData)
                            }

                            completion(images, imageNames, info)
                            print("Successfully downloaded json info")
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                }
            })
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
