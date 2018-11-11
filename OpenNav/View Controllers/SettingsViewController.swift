//
//  SettingsViewController.swift
//  Navigate HoCo
//
//  Created by Sylvan Martin on 8/23/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

// FILE INFO
/*
 basic view for settings menu

 also handles getting layouts from server
 */

import UIKit

class SettingsViewController: UITableViewController, UITextFieldDelegate {

    let server = ServerCommunicator()
    let settings = UserSettings()
    let dict = BuildingInfoDictionaryItemNames()

    // MARK: Properties

    @IBOutlet var codeTextInput: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        // title the view
        self.navigationItem.title = "Settings"

        // this keeps the text in the "code input" field consistent even when the app is closed. This is just for looks. Removing this code will not affect the functionality of the app
        if let prevInput = settings.get(setting: .layoutCode) as? String {
            codeTextInput.text = prevInput
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let setting = UserSettings()
        switch setting.get(setting: .darkMode) as! Bool {
        case true:
            break
        case false:
            break
        }
    }

    // MARK: Actions

    // called when "go" button is pressed on the keyboard for the code input field
    @IBAction func userEnteredCode(_ sender: Any) {
        if codeTextInput.text != nil {  // detect if there is in fact text
            settings.set(codeTextInput.text as Any, for: .layoutCode) // save text so it will be there when user reloads the view

            // dismiss keyboard
            view.endEditing(true)
            codeTextInput.resignFirstResponder()
            codeTextInput.endEditing(true)
            
            getLayouts(code: codeTextInput.text!)
        } else {
            // no text entered
        }
    }
    
    // MARK TableView
    
    
}
