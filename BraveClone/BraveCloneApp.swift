//
//  BraveCloneApp.swift
//  BraveClone
//
//  Created by ryo on 2022/10/11.
//

import SwiftUI

@main
struct BraveCloneApp: App {
    
    init() {
        if !AppConstants.isRunningTest {
            @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
