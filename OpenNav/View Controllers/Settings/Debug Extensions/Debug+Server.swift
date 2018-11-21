//
//  Debug+Server.swift
//  OpenNav
//
//  Created by Sylvan Martin on 11/14/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import Alamofire

extension DebugViewController {
    
    func contactServer(url: URL) {
        
        activityIndicator.startAnimating()
        
        Alamofire.request(url).response { response in
            
            let responseString = String(data: response.data!, encoding: .utf8)
            
            self.outputTextView.text = responseString
            
            self.activityIndicator.stopAnimating()
        }
 
    }
    
}
