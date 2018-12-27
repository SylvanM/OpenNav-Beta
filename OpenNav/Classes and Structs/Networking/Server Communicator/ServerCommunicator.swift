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
    
    let baseURLString      = "https://navdataservice.000webhostapp.com/"
    let usersURLString     = "https://navdataservice.000webhostapp.com/users.php?f="
    let layoutsURLString   = "https://navdataservice.000webhostapp.com/layouts/layouts.php?f="

    var key : [UInt8]!
    var iv  : [UInt8]!

    enum ServerError: Error {
        case code404
    }

    func getLayout(code: String, completion: @escaping ([String : JSON?]) -> ()) {
        var layout: [String : JSON?] = [:] // object to return when requests are done
        let request = LayoutRequest(code, id: UserDefaults.standard.string(forKey: "appID")!)
        
        let targetResponseNumber = LayoutRequest.LayoutFunction.allCases.count - 1// amount of responses that must be recieved for the request to be complete
        var responseWatcher: Int = 0 {
            // once a response is in, this value will increment. When it gets to the target number, it calls completion
            didSet {
                if responseWatcher == targetResponseNumber {
                    completion(layout)
                }
            }
        }
        
        print("Crypto request url: ", request.urls["crypto"])
        Alamofire.request(request.urls["crypto"]!).responseJSON { (response) in
            // crypto information has been retrieved, now we can collect the rest of the information
            print("Crypto request made")
            var cryptokey: Data // encryption key
            var cryptoiv:  Data // encryption iv
            
            do {
                let cryptoJson = try JSON(data: response.data!)
                let keyString = cryptoJson["key"].stringValue
                let ivString  = cryptoJson["iv"].stringValue
                
                print("Crypto: ", keyString, " ", ivString)
                
                cryptokey = Data(bytes: keyString.bytes)
                cryptoiv = Data(bytes: ivString.bytes)
            } catch {
                // invalid response?
                print("Error on downloading crypto info: ", error)
            }
            
            for (key, url) in request.urls where key != "crypto" {
                // call the other requests
                Alamofire.request(url).responseJSON(completionHandler: { response in
                    var decryptedResponse: Data = response.data!
                    var json: JSON?
                    do { // decrypt the data
//                        decryptedResponse = (try response.data?.decrypt(key: cryptokey, iv: cryptoiv))!
                        // this is commented out because right now there is no encryption involved. Once there is, this line will be uncommented.
                        
                        json = try JSON(data: decryptedResponse)
                    } catch {
                        print(error)
                    }
                    
                    if let recievedJson = json {
                        layout[key] = recievedJson
                    } else {
                        layout[key] = nil
                    }
                    responseWatcher += 1 // let the watcher know that another item has been recieved and downlaoded
                })
            }
            
        }
        
    }
    
    func testCode(_ code: String, completion: @escaping (Bool) -> ()) {
        // generate test url
        let urlString = layoutsURLString + "testCode&code=\(code)"
        let url = URL(string: urlString)!
        
        print("Layout test url: ", url)
        
        Alamofire.request(url).responseString() { response in
            
            let responseData = response.data!
            let responseString = String(data: responseData, encoding: .utf8)
            
            print("Response from layout test request: ", responseString ?? "No response")
            
            if responseString == "1" {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

}
