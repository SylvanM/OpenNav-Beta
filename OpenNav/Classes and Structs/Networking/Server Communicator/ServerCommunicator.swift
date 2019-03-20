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
import CryptoSwift

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
        
        //print("Crypto request url: ", request.urls["crypto"])
        
        Alamofire.request(request.urls["crypto"]!).responseData { (response) in
            // crypto information has been retrieved, now we can collect the rest of the information
            let encryptedData = response.data!
            var decryptedData: Data
            
            print("Recieved data: ", encryptedData)
            
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
                
                cryptokey = keyString.data(using: .utf8)! // make Data instances from collected strings
                cryptoiv  = ivString.data(using: .utf8)!  // same here

                let decryption: (Bool, Data?, Data?) = (true, cryptokey, cryptoiv) // this is the encryption instruction to give to the downloadLayoutItem function. For now, it is nil because all data is decrypted
                
                for (key, url) in request.urls where (key != "crypto") {
                    // call the other requests, we have the decryption info!
                    
                    self.downloadLayoutItem(url: url, withDecryption: decryption, item: key) { json in
                        
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
        
        print("Testing: ", url)
        
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
    func downloadLayoutItem(url: URL, withDecryption shouldDecrypt: (Bool, Data?, Data?), item: String? = nil, completion: @escaping (JSON?) -> ()) {
        
        
        
        Alamofire.request(url).responseString() { response in
            if let thing = item { // just for debugging
                print("Downloading", thing)
                print("Will decrypt \(thing):", shouldDecrypt.0)
            }
            
            var json: JSON?
            
            if shouldDecrypt.0 {
                do {
                    
                    let encodedString = String(data: response.data!, encoding: .utf8)!.replacingOccurrences(of: " ", with: "+")
                    let encryptedData = Data(base64Encoded: encodedString)!
                    let decryptedData = try encryptedData.decrypt(key: shouldDecrypt.1!, iv: shouldDecrypt.2!)
                    let decryptedString = String(data: decryptedData, encoding: .utf8)!
                    
                    print("Decrypted \(item!) to find:\n", decryptedString)
                    
                    
                    json = JSON(parseJSON: decryptedString)
                    
                } catch AES.Error.dataPaddingRequired {
                    print("Data padding required: ", url)
                } catch {
                    print("ERROR: ", error)
                }
            } else {
                // response data is in plaintext, it's fine to set as the jsonData
                do {
                    json = try JSON(data: response.data!)
                } catch {
                    print("JSON ERROR: ", error)
                }
            }
            
            // run completion
            completion(json)
        }
        
    }

}
