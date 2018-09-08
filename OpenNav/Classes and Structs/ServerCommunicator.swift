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

    enum ServerError: Error {
        case code404
    }

    func getImage(forCode: String, image: String, completion: @escaping (_ image: UIImage) -> ()) {
        let request = BuildingInfoRequest(code: forCode, image: image)
        print(request.url)

        if verifyUrl(urlString: request.url) {
            Alamofire.request(request.url).responseData { (response) in
                if response.error != nil {
                    // Handle error
                } else {
                    do {
                        let decryptedData = try response.data?.decrypt(key: Data(bytes: "passwordpassword".bytes), iv: Data(bytes: "drowssapdrowssap".bytes))
                        let imageFromData = UIImage(data: decryptedData!)

                        completion(imageFromData!)
                    } catch {
                        print(error)
                    }
                }
            }
        } else {
            //throw ServerError.code404
        }
    }

    func getBuildingData(forCode: String, completion: @escaping (_ infoDictionary: JSON) -> ()) {

        let request = BuildingInfoRequest(code: forCode, fileName: "information.json")

        if verifyUrl(urlString: request.url) {
            Alamofire.request(request.url).responseData { (response) in
                if response.error != nil {
                    // Handle error
                } else {
                    do {
                        let decryptedData = try response.data?.decrypt(key: Data(bytes: "passwordpassword".bytes), iv: Data(bytes: "drowssapdrowssap".bytes))
                        let jsonData = try? JSON(data: decryptedData!)

                        completion(jsonData!)
                    } catch {
                        print(error)
                    }
                }
            }
        } else {
            //throw ServerError.code404
        }
    }

    // TODO: Make this function detect if url will give 404 status code!
    func verifyUrl(urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }

    struct BuildingInfoRequest {
        let baseURL = "https://navdataservice.000webhostapp.com/layouts/"

        var code: String
        var desiredImageName: String!
        var desiredFileName: String!

        var urlString: String
        var url: String

        init(code: String, image: String) {
            self.code = code
            self.desiredImageName = image

            urlString = baseURL + code + "/" + image

            url = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        }

        init(code: String, fileName: String) {
            self.code = code
            self.desiredFileName = fileName

            urlString = baseURL + code + "/" + fileName

            url = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        }
    }

}
