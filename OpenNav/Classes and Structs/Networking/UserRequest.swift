//
//  UserRequest.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/22/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

struct UserRequest: Request {
    
    var function: UserFunction
    var arguments: [String : String]
    
    var url: URL {
        var urlString = "https://navdataservice.000webhostapp.com/users.php?f=\(function.rawValue)"
        for (key, value) in arguments {
            urlString += "&\(key)=\(value)"
        }
        return URL(string: urlString)!
    }
    
    init(_ function: UserFunction, arguments: [String : String]) {
        self.function = function
        self.arguments = arguments
    }
    
    enum UserFunction: String {
        case addUser = "addUser"
        case removeUser = "removeUser"
        case testUser = "testUser"
        case updateUser = "updateUser"
    }
    
}
