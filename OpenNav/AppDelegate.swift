//
//  AppDelegate.swift
//  OpenNav
//
//  Created by Sylvan Martin on 9/8/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit
import CryptoSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let settings = UserSettings()
    let server = ServerCommunicator()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        NotificationCenter.default.addObserver(self, selector: #selector(redTint), name: .redTint, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(blueTint), name: .blueTint, object: nil)
        
        if let tint = settings.get(setting: .tint) as? String, tint == "red" {
            redTint()
        } else {
            blueTint()
        }
        
        // generate and upload app ID
        if UserDefaults.standard.string(forKey: "appID") == nil {
            let baseIntA = Int(arc4random() % 65535)
            let baseIntB = Int(arc4random() % 65535)
            let baseIntC = Int(arc4random() % 65535)
            let hex = String(format: "%02x%02x%02x", baseIntA, baseIntB, baseIntC)
            UserDefaults.standard.set(hex, forKey: "appID")
            
            server.uploadKey(for: hex, key: "test_key")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Methods
    
    @objc func redTint() {
        window?.tintColor = UIColor.red
        settings.set("red", for: .tint)
    }
    
    @objc func blueTint() {
        window?.tintColor = UIColor(red: 0.0, green: 122.0/225.0, blue: 1.0, alpha: 1.0)
        settings.set("blue", for: .tint)
    }
}
