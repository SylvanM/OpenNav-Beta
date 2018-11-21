//
//  DebugViewController.swift
//  OpenNav
//
//  Created by Sylvan Martin on 11/14/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit
import Alamofire

class DebugViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var outputTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Debug"

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: Actions
    
    
    @IBAction func contactServer(_ sender: Any) {
        if let url = URL(string: textField.text!) {
        activityIndicator.startAnimating()
        contactServer(url: url)
    } else {
        outputTextView.text = "no input"
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
