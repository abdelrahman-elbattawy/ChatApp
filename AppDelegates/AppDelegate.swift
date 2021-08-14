//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Aboody on 19/07/2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var firstRun: Bool?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        firstRunCheck()
        
        LocationManager.shared.startUpdating()
        
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    //MARK: - Helpers Functions
    private func firstRunCheck() {
        firstRun = userDefaults.bool(forKey: kFIRSTRUN)
        
        if !firstRun! {
        
            let status = Status.allCases.map { $0.rawValue }
            
            userDefaults.set(status, forKey: kSTATUS)
            userDefaults.set(true, forKey: kFIRSTRUN)
            
            userDefaults.synchronize()
            
        }
        
    }

}

