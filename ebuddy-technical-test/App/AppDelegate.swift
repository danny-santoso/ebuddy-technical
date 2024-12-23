//
//  AppDelegate.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/19/24.
//

import FirebaseCore
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        print("Uploading URLSession for \(identifier) is Running")
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}
