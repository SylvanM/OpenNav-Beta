//
//  UserSettings.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/31/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

class UserSettings {
    
    var dict: [String : Any] {
        didSet {
            saveSettings()
        }
    }
    
    var filePath: URL
    
    init() {
        filePath = getDocumentsDirectory()
        filePath.appendPathComponent("user_settings.plist")
        
        if let dict = NSDictionary(contentsOf: filePath) {
            self.dict = (dict as Any) as! [String : Any]
        } else {
            // no previous settings set, so generate default settings
            self.dict = [
                            Setting.darkMode.rawValue: false,
                            Setting.tint.rawValue: "blue",
                            Setting.layoutCode.rawValue: ""
                ] as [String : Any]
        }
    }
    
    func get(setting: Setting) -> Any {
        return self.dict[setting.rawValue] as Any
    }
    
    func set(_ value: Any, for setting: Setting) {
        self.dict[setting.rawValue] = value
    }
    
    func saveSettings() {
        let dictData = NSDictionary(dictionary: self.dict)
        
        do {
            try dictData.write(to: filePath)
        } catch {
            print("error on saving user setting: \(error)")
        }
    }
    
    enum Setting : String {
        case darkMode = "darkMode"
        case tint = "appTint"
        case layoutCode = "codeInputText"
    }
    
}
