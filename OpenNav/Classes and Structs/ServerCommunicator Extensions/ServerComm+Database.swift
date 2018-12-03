//
//  ServerComm+URL.swift
//  OpenNav
//
//  Created by Sylvan Martin on 11/22/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import Alamofire

extension ServerCommunicator {
    
    struct DatabaseRequest {
        var function: DatabaseAction
        var arguments: [String : String]
        
        init(function: DatabaseAction, arguments: [String : String]) {
            self.function = function
            self.arguments = arguments
        }
        
        func url() -> URL {
            var baseURL = databaseUrl
            baseURL += function.rawValue
            
            for (arg, value) in arguments {
                baseURL += String("&\(arg)=\(value)")
            }
            
            let url = URL(string: baseURL)!
            
            return url
        }
    }
    
    enum DatabaseAction : String {
        case addUser = "addUser"
        case removeUser = "removeUser"
        case testUser = "testUser"
    }
}
