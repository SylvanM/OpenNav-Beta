//
//  Key Upload.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/22/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import Alamofire

extension ServerCommunicator {
    func uploadKey(for appID: String, key: String) {
        let arguments: [String : String] = [
            "id" : appID,
            "key": key
        ]
        
        let testRequest   = UserRequest(.testUser, arguments: arguments)
        let addRequest    = UserRequest(.addUser, arguments: arguments)
        let updateRequest = UserRequest(.updateUser, arguments: arguments)
        
        Alamofire.request(testRequest.url).responseString() { response in
            if let responseString = String(data: response.data!, encoding: .utf8) {
                if responseString == "0" {
                    Alamofire.request(addRequest.url)
                    print("adding appID to server: ", addRequest.url)
                } else {
                    Alamofire.request(updateRequest.url)
                    print("updating user key: ", updateRequest.url)
                }
            }
        }
    }
}
