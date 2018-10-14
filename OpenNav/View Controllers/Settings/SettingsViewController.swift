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
        // couldn't change it in storyboard so I did it here
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

                let alertController = UIAlertController(title: "Downloading Layouts", message: "This may take a couple seconds", preferredStyle: .alert)

                self.present(alertController, animated: true, completion: nil)

                let building = BuildingInfo("dummy") // make instance of SchoolInfo with all blank data, this is what we will save to UserDefaults later
                let buildingCode = codeTextInput.text


                // This is test code. It might not work. That is why we are keeping the previous commented code
                server.getBuildingData(forCode: buildingCode!, completion: { (images, names, infoDictionary) in
                    
                    // save the basic data from the school info from information.json
                    if images.first == images.last {
                        print("Images are not different")
                    } else {
                        print("Images are different")
                    }
                    
                    building.info = infoDictionary.dictionaryObject
                    building.info[self.dict.floorCount] = images.count

                    building.imageNames = names
                    building.floorImages = images
                    building.saveData()

                    alertController.dismiss(animated: true, completion: nil)
                    
                    _ = self.navigationController?.popViewController(animated: true)
                })

            } catch {
                let ac = UIAlertController(title: "Unable to retrieve building data", message: "Please double check the code you entered", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                ac.addAction(confirmAction)

                present(ac, animated: true, completion: nil)
            }
        } else {
            // no text entered
        }
    }
}
