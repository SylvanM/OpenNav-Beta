//
//  Notification+Extension.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/24/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let darkModeEnabled = Notification.Name("com.OpenNav.notifications.darkModeEnabled")
    static let darkModeDisabled = Notification.Name("com.OpenNav.notifications.darkModeDisabled")
    
    static let redTint = Notification.Name("com.OpenNav.notifications.enableRedTint")
    static let blueTint = Notification.Name("com.OpenNav.notifications.enableBlueTint")
}
