//
//  POSTRequestTestViewController.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/15/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
 * DEBUG Class
 * Class for debuging and testing all the "post" request functions in ServerCommunicator
 * This class controls the POST Request Viw
 */

class POSTRequestTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title the view
        self.navigationItem.title = "POST Request"
        
        let server = ServerCommunicator()
        
        // run simple post request
        
        let info: [String : Any] = [
            "Hello": "World"
        ]
            
        server.postDataToServer(data: JSON(info), to: "debug")

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
