//
//  SceneDelegate.swift
//  ChatApp
//
//  Created by Aboody on 19/07/2021.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var authListener: AuthStateDidChangeListenerHandle?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        autoLogin()
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
        LocationManager.shared.startUpdating()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
        LocationManager.shared.stopUpdating()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
        LocationManager.shared.stopUpdating()
    }
    
    //MARK: - Autologin
    private func autoLogin() {
        
        authListener = Auth.auth().addStateDidChangeListener({ (auth, user) in
            
            Auth.auth().removeStateDidChangeListener(self.authListener!)
            
            if user != nil && userDefaults.object(forKey: kCURRENTUSER) != nil {
                DispatchQueue.main.async {
                    self.goToApp()
                }
            } else {
                DispatchQueue.main.async {
                    self.gotToLogin()
                }
            }
        })
    }
    
    private func goToApp() {
        
        let tabBar = BaseTBVC()
        self.window?.rootViewController = tabBar
    }
    
    private func gotToLogin() {
        let loginVC = LoginVC()
        self.window?.rootViewController = loginVC
    }
}

