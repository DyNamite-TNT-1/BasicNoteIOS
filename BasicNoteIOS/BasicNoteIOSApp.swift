//
//  BasicNoteIOSApp.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/6/23.
//

import SwiftUI

@main
struct BasicNoteIOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            AppContainer()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("active")
            } else if newPhase == .inactive {
                print("inactive")
            } else if newPhase == .background {
                print("background")
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UIApplication.shared.applicationIconBadgeNumber = 0
        UserDefaults.standard.set(0, forKey: "NotificationCountBadge")
        print("Finished Launching")
        return true
    }
    
}
