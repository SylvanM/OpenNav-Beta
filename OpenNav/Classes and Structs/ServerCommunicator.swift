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

        if verifyURL(url: request.url) {
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


        if verifyURL(url: request.url) {
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
                            
                            print("key: \(String(describing: String(data: keyData, encoding: .utf8)))")
                            print("iv: \(String(describing: String(data: ivData, encoding: .utf8)))")
                            
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
                                reversedImageNames.append(floorName.1.stringValue)
                                
                                print("Floor from JSON: \(floorName.1.stringValue)")
                                
                                self.getImage(code: code, name: floorName.1.stringValue, decryptionInfo: (keyData, ivData)) { image in
                                    images.append(image)
                                    
                                    if collectedFloorCount == nil {
                                        collectedFloorCount = 1
                                    } else {
                                        collectedFloorCount += 1
                                    }
                                }
                            }
   
                        } catch {
                            print(error)
                        }
                    }
                }
            })
        }
    }
    
    func getImage(code: String, name: String, decryptionInfo: (Data, Data), completion: @escaping (UIImage) -> ()) {
        
        let urlString = navdataserviceURL + code + "/" + name + ".png"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
        print("Image URL: \(url)")
        
        Alamofire.request(url).responseData() { response in
            let encryptedData = response.data!
            do {
                let data = try encryptedData.decrypt(key: decryptionInfo.0, iv: decryptionInfo.1)
                let image = UIImage(data: data)!
                
                completion(image)
            } catch {
                print("Error on decryption of image: \(error)")
            }
        }
    }
    
    func verifyURL(url: String) -> Bool {
        return true
    }
    
    func uploadKey(for appID: String, key: String) {
        let urlString = "http://navdataservice.000webhostapp.com/database.php?f=addUser&id=" + appID + "&key=" + key
        let url = URL(string: urlString)!
        
        print("upload url: ", urlString)
        
        Alamofire.request(url)
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
