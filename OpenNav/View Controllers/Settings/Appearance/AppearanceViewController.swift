//
//  AppearanceViewController.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/24/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit

class AppearanceViewController: UITableViewController {
    
    let settings = UserSettings()

    // MARK: Properties
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var blueTintButton: UITableViewCell!
    @IBOutlet weak var redTintButton: UITableViewCell!
    @IBOutlet weak var darkModeCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Appearance"
        
        darkModeSwitch.isOn = settings.get(setting: .darkMode) as! Bool
        
        blueTintButton.accessoryType = .none
        redTintButton.accessoryType = .none
        
        if let tint = settings.get(setting: .tint) as? String, tint == "red" {
            redTintButton.accessoryType = .checkmark
        } else {
            blueTintButton.accessoryType = .checkmark
        }
    }
    
    // MARK: Actions
    
    @IBAction func toggleDarkMode(_ sender: Any) {
        let darkMode = darkModeSwitch.isOn
        
        switch darkMode {
        case true:
            NotificationCenter.default.post(Notification(name: .darkModeEnabled))
            
            print(UIApplication.shared.setAlternateIconName("AppIcon-DarkMode", completionHandler: { (error) in
                print("Error on changing to dark icon:", error as Any)
                print("Current app name:", UIApplication.shared.alternateIconName as Any)
            }))
            
        case false:
            NotificationCenter.default.post(Notification(name: .darkModeDisabled))
            
            UIApplication.shared.setAlternateIconName(nil) { (error) in
                print("Error on changing to light icon:", error as Any)
                print("Current app name:", UIApplication.shared.alternateIconName as Any)
            }
        }
        
    }
    
    // MARK: Table View
    
    // change tint
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        if selectedCell != darkModeCell {
            blueTintButton.accessoryType = .none
            redTintButton.accessoryType = .none
            
            selectedCell?.accessoryType = .checkmark
            
            switch selectedCell {
            case blueTintButton:
                NotificationCenter.default.post(Notification(name: .blueTint))
            case redTintButton:
                NotificationCenter.default.post(Notification(name: .redTint))
            case .none:
                // this case should never be true
                print("None selected")
            case .some(_):
                // this case should never be true
                print("Multiple selected")
            }
        }
        
    }
    
}
