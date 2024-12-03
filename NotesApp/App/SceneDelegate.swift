//
//  SceneDelegate.swift
//  NotesApp
//
//  Created by Tuna Demirci on 23.11.2024.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let authManager = AuthManager()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
       
        authManager.checkUserAuthentication { isAuthenticated in
            if isAuthenticated {
                let homeVC = HomeViewController()
                let startViewController = UINavigationController(rootViewController: homeVC)
                self.window?.rootViewController = startViewController
            } else {
                let logInVC = LogInViewController()
                let startViewController = UINavigationController(rootViewController: logInVC)
                self.window?.rootViewController = startViewController
            }
            self.window?.makeKeyAndVisible()
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

