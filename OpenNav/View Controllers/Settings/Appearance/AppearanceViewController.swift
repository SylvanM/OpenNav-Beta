//
//  AppearanceViewController.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/24/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit

class AppearanceViewController: UITableViewController {
    
    let keys = Keys()

    // MARK: Properties
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var blueTintButton: UITableViewCell!
    @IBOutlet weak var redTintButton: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Appearance"
        
        darkModeSwitch.isOn = UserDefaults.standard.bool(forKey: keys.darkMode)
        
        blueTintButton.accessoryType = .none
        redTintButton.accessoryType = .none
        
        if let tint = UserDefaults.standard.object(forKey: keys.tint) as? String, tint == "red" {
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
            
            // do default tint
            redTintButton.accessoryType = .none
            blueTintButton.accessoryType = .checkmark
        case false:
            NotificationCenter.default.post(Notification(name: .darkModeDisabled))
        }
        
    }
    
    // MARK: Table View
    
    // change tint
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        if !darkModeSwitch.isOn {
            blueTintButton.accessoryType = .none
            redTintButton.accessoryType = .none
            
            selectedCell?.accessoryType = .checkmark
            
            if selectedCell == blueTintButton {
                NotificationCenter.default.post(Notification(name: .blueTint))
            } else {
                NotificationCenter.default.post(Notification(name: .redTint))
            }
        }
    }
    
}
