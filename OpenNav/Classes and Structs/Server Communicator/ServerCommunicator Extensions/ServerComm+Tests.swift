//
//  ServerComm+Tests.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/5/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import Alamofire

extension ServerCommunicator {
    
    func test(_ request: Request, completion: @escaping (Data) -> ()) {
        
        let url = request.url()
        
        Alamofire.request(url).responseData { (response) in
            completion(response.data!)
        }
        
    }
    
}
