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
    let keys = Keys()
    let dict = BuildingInfoDictionaryItemNames()

    // MARK: Properties

    @IBOutlet var codeTextInput: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        // title the view
        self.navigationItem.title = "Settings"

        // this keeps the text in the "code input" field consistent even when the app is closed. This is just for looks. Removing this code will not affect the functionality of the app
        if let prevInput = UserDefaults.standard.object(forKey: "codeInputText") as? String {
            codeTextInput.text = prevInput
        }

    }

    // MARK: Actions

    // called when "go" button is pressed on the keyboard for the code input field
    @IBAction func userEnteredCode(_ sender: Any) {
        if codeTextInput.text != nil {  // detect if there is in fact text
            UserDefaults.standard.set(codeTextInput.text, forKey: keys.layoutCode) // save text so it will be there when user reloads the view

            // dismiss keyboard
            view.endEditing(true)
            codeTextInput.resignFirstResponder()
            codeTextInput.endEditing(true)
            do {
                // make pop-up to let user know that layouts are being downloaded
                let alertController = UIAlertController(title: "Downloading Layouts", message: "This may take a couple seconds", preferredStyle: .alert)

                self.present(alertController, animated: true, completion: nil)
                
                // make instance of SchoolInfo with all blank data, this is what we will save to UserDefaults later
                // this is like making an empty string and adding stuff to it later on, then returning the final string
                let building = BuildingInfo("dummy")
                let buildingCode = codeTextInput.text

                server.getBuildingData(forCode: buildingCode!, completion: { (images, imageNames, infoDictionary) in
                    
                    // assign items in info dictionary to items from downloaded JSON
                    let presentableInfo = infoDictionary.dictionaryObject
                    let layoutData: [String : Any] = [
                        self.dict.floorCount: images.count,
                        self.dict.imageNames: imageNames
                    ]
                    
                    building.info = [
                        self.dict.presentableInfo: presentableInfo as Any,
                        self.dict.layoutData: layoutData as Any
                    ]
                    
                    // save images to building instance
                    building.floorImages = images
                    building.saveData() // save the building to userdefaults to be used by other classes (primarily the Map View)

                    alertController.dismiss(animated: true, completion: nil)
                    
                    _ = self.navigationController?.popViewController(animated: true) // jump back to root view controller
                })

            }
            // No errors are actuall thrown in the "do" block, so there isn't any point for this catch block
            // Not gonna delete this block because it may come in handy later
//            catch {
//                let ac = UIAlertController(title: "Unable to retrieve building data", message: "Please double check the code you entered", preferredStyle: .alert)
//                let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//                ac.addAction(confirmAction)
//
//                present(ac, animated: true, completion: nil)
//            }
        } else {
            // no text entered
        }
    }
}
