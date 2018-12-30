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
        
        let targetResponseNumber = LayoutRequest.LayoutFunction.allCases.count - 1 // amount of responses that must be recieved for the request to be complete
        var responseWatcher: Int = 0 {
            // once a response is in, this value will increment. When it gets to the target number, it calls completion
            didSet {
                if responseWatcher == targetResponseNumber {
                    completion(layout)
                }
            }
        }
        
        print("Crypto request url: ", request.urls["crypto"])
        
        Alamofire.request(request.urls["crypto"]!).responseData { (response) in
            // crypto information has been retrieved, now we can collect the rest of the information
            let encryptedData = response.data!
            var decryptedData: Data
            
            // ok now collect the data
            var cryptokey: Data // encryption key, this will be set when teh crypto response is decrypted
            var cryptoiv:  Data // encryption iv
            
            // must decrypt response with private key
            
            do {
                let rsa = try RSA.generateFromBundle() // get saved RSA keys
                
                decryptedData = rsa.decrypt(encryptedData) // decrypt data from web service with saved rsa
                
                let cryptoJson = try JSON(data: decryptedData) // construct json from decrypted json
                let keyString  = cryptoJson["key"].stringValue
                let ivString   = cryptoJson["iv"].stringValue
                
                cryptokey = Data(bytes: keyString.bytes) // make Data instances from collected strings
                cryptoiv  = Data(bytes: ivString.bytes)  // same here

                let decryption: (Bool, Data?, Data?) = (true, cryptokey, cryptoiv) // this is the encryption instruction to give to the downloadLayoutItem function. For now, it is nil because all data is decrypted
                
                for (key, url) in request.urls where key != "crypto" {
                    // call the other requests, we have the decryption info!
                    
                    self.downloadLayoutItem(url: url, withDecryption: decryption) { json in
                        if let recievedJson = json {
                            layout[key] = recievedJson
                        } else {
                            layout[key] = nil
                        }
                        responseWatcher += 1 // let the watcher know that another item has been recieved and downlaoded
                    }
                }
                
            } catch {
                print("Error: ", error)
            }
            
        }
        
    }
    
    // test to see if the layout exists. Whether it exists is stored in a bool. A completion is run with the bool as an argument
    func testCode(_ code: String, completion: @escaping (Bool) -> ()) {
        // generate test url
        let urlString = layoutsURLString + "testCode&code=\(code)"
        let url = URL(string: urlString)!
        
        Alamofire.request(url).responseString() { response in
            let responseData = response.data!
            let responseString = String(data: responseData, encoding: .utf8)
            
            if responseString == "1" {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // download a specific aspect of the layout
    func downloadLayoutItem(url: URL, withDecryption shouldDecrypt: (Bool, Data?, Data?), completion: @escaping (JSON?) -> ()) {
        
        Alamofire.request(url).responseData() { response in
            
            let responseData = response.data! // data returned from server, potentially encrypted
            var json: JSON?
            
            var jsonData: Data? // data to make json out of
            
            if shouldDecrypt.0 {
                do {
                    // decrypt the response data, make THAT the thing to construct the json out of
                    jsonData = try responseData.decrypt(key: shouldDecrypt.1!, iv: shouldDecrypt.2!)
                } catch {
                    print("Error on decryption: ", error)
                }
            } else {
                // response data is in plaintext, it's fine to set as the jsonData
                jsonData = responseData
            }
            
            // construct data from jsonData
            do {
                if let data = jsonData {
                    json = try JSON(data: data)
                }
            } catch {
                print("Error on constructing json from response data: ", error)
            }
            
            print("Downloaded JSON: ", json)
            
            // run completion
            completion(json)
        }
        
    }

}
