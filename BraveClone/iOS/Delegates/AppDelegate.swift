//
//  AppDelegate.swift
//  BraveClone
//
//  Created by ryo on 2022/10/12.
//

import Foundation
import UIKit


class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setUpWebServer()
        return true
    }
    
    func setUpWebServer() {
        let server = WebServer.shared
        guard !server.server.isRunning else { return }
        
        do {
            try server.start()
        } catch let err as NSError {
            print("Error: Unable to start WebServer \(err)")
        }
    }
}

extension AppDelegate {
    // MARK: UISession Lifecycle
    func application(_ applicaiton: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: connectingSceneSession.configuration.name, sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }
}
