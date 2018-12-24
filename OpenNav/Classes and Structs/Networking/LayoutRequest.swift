//
//  RequestGroup.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/22/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

struct LayoutRequest {
    var arguments: [String : String]
    
    var urls: [String : URL] {
        var tempDict: [String : URL] = [:]
        for function in LayoutFunction.allCases {
            var urlString = "https://navdataservice.000webhostapp.com/layouts/layouts.php?f=get\(function.rawValue)"
            for (key, value) in arguments {
                urlString += "&\(key)=\(value)"
            }
            let url = URL(string: urlString)!
            tempDict[function.rawValue] = url
        }
        return tempDict
    }
    
    init(_ code: String, id: String) {
        arguments = [
            "id"  : id,
            "code": code
        ]
    }
    
    enum LayoutFunction: String, CaseIterable {
        case getImages = "images"
        case getLayout = "layout"
        case getInfo   = "info"
        case getCrypto = "crypto"
    }
    
}
