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
import UIKit

class ServerCommunicator {
    
    let baseURLString      = "https://navdataservice.000webhostapp.com/"
    let layoutsURLString   = "https://navdataservice.000webhostapp.com/layouts.php?f="

    enum ServerError: Error {
        case code404
    }

    func getLayout(code: String, completion: @escaping ([String : JSON?]) -> ()) {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest  = TimeInterval(60.0)
        manager.session.configuration.timeoutIntervalForResource = TimeInterval(60.0)
        
        
        var layout: [String : JSON?] = [:] // object to return when requests are done
    
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let parts = ["l", "r", "e", "i"]
        
        let fileURLS: [String : URL] = [
            "l" : directoryURL.appendingPathComponent("temp_layout"),
            "r" : directoryURL.appendingPathComponent("temp_rooms"),
            "e" : directoryURL.appendingPathComponent("temp_info"),
            "i" : directoryURL.appendingPathComponent("temp_images")
        ]
        
        var downloadedPartsCount: Int = 0 {
            didSet {
                if downloadedPartsCount == parts.count {
                    
                    for (part, url) in fileURLS {
                        
                        var fullPartName: String {
                            switch part {
                            case "l":
                                return "layout"
                            case "r":
                                return "rooms"
                            case "e":
                                return "info"
                            case "i":
                                return "images"
                            default:
                                return part
                            }
                        }
                        
                        do {
                            let encodedData      = try String(contentsOf: url)
                            let data             = Data(base64Encoded: encodedData)!
                            layout[fullPartName] = try JSON(data: data)
                            try fileManager.removeItem(at: url) // file already used, so delete it
                        } catch {
                            print("Error on getting info from", url)
                        }
                        completion(layout)
                    }
                }
            }
        }
        
        let urls  = parts.map { URL(string: (layoutsURLString + "d&c=\(code)&p=\($0)"))! }
        
        for i in 0..<parts.count {
            let destination: DownloadRequest.DownloadFileDestination = { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
                let url = fileURLS[parts[i]]
                return (url!, .removePreviousFile)
            }
            
            manager.download(urls[i], to: destination).downloadProgress { progress in
                // no nothing
            }.response { _ in
                print("Success!")
                downloadedPartsCount += 1
            }
        }
    }
    
    // test to see if the layout exists. Whether it exists is stored in a bool. A completion is run with the bool as an argument
    func testCode(_ code: String, completion: @escaping (Bool) -> ()) {
        // generate test url
        let urlString = layoutsURLString + "t&c=\(code)"
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
}
