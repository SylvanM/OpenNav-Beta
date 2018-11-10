//
//  NavigationViewController.swift
//  OpenNav
//
//  Created by Sylvan Martin on 11/3/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit

class NavigationViewController: UIViewController {
    
    var baseImages: [UIImage]?
    var start: Int?
    var end:   Int?
    
    let settings = UserSettings()
    
    // MARK: View Controllers

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch settings.get(setting: .darkMode) as! Bool {
        case true:
            self.navigationController?.navigationBar.barStyle = .black
        case false:
            self.navigationController?.navigationBar.barStyle = .default
        }
    }
    
    // MARK: Actions
    
    @objc
    func dismissNavView(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
