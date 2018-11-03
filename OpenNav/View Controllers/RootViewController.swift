//
//  RootViewController.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/26/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit

class RootViewController: UINavigationController {
    
    let settings = UserSettings()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.barStyle = .default
        
        // set observers
        NotificationCenter.default.addObserver(self, selector: #selector(saveDarkMode), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveLightMode), name: .darkModeDisabled, object: nil)

        print("Dark mode: \(settings.get(setting: .darkMode))")
        // Do any additional setup after loading the view.
        switch settings.get(setting: .darkMode) as! Bool {
        case true:
            setDarkMode()
            print("Setting light mode")
        case false:
            setLightMode()
            print("Setting dark mode")
        }
    }
    
    @objc func saveDarkMode() {
        setDarkMode()
        settings.set(true, for: .darkMode)
    }
    
    @objc func saveLightMode() {
        setLightMode()
        settings.set(false, for: .darkMode)
    }
    
    func setLightMode() {
        navigationBar.barStyle = .default
        toolbar.barStyle = .default
    }
    
    func setDarkMode() {
        navigationBar.barStyle = .blackTranslucent
        toolbar.barStyle = .blackTranslucent
        
        NotificationCenter.default.post(Notification(name: .blueTint))
    }

}
