//
//  RootViewController.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/26/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit

class RootViewController: UINavigationController {
    
    let keys = Keys()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.barStyle = .default
        
        // set observers
        NotificationCenter.default.addObserver(self, selector: #selector(saveDarkMode), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveLightMode), name: .darkModeDisabled, object: nil)

        print("Dark mode: \(UserDefaults.standard.bool(forKey: keys.darkMode))")
        // Do any additional setup after loading the view.
        switch UserDefaults.standard.bool(forKey: keys.darkMode) {
        case true:
            setDarkMode()
            print("Setting light mode")
        case false:
            setLightMode()
            print("Setting dark mode")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func saveDarkMode() {
        setDarkMode()
        UserDefaults.standard.set(true, forKey: keys.darkMode)
    }
    
    @objc func saveLightMode() {
        setLightMode()
        UserDefaults.standard.set(false, forKey: keys.darkMode)
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
