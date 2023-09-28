//
//  SettingViewModel.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/18/23.
//

import Foundation
import UserNotifications
import SwiftUI

class SettingViewModel: ObservableObject {
    ///To indicate status of Local Notification
    ///
    ///0: first time to visit app
    ///
    ///1: authorized
    ///
    ///-1: denied
    @Published var localNotiStatus: Int = 0 {
        didSet {//didSet is called whether localNotiStatus is changed
            UserDefaults.standard.set(localNotiStatus, forKey: localNotiKey)
        }
    }
    
    @Published var toggleNotiStatus: Bool = false {
        didSet {//didSet is called whether toggleNotiStatus is changed
            UserDefaults.standard.set(toggleNotiStatus, forKey: toggleNotiKey)
        }
    }
    
    let localNotiKey:String = "localNotiKey"
    let toggleNotiKey: String = "toggleNotiKey"
    
    init(){
        getData()
    }
    
    func getData() {
        localNotiStatus = UserDefaults.standard.integer(forKey: localNotiKey)
        toggleNotiStatus = UserDefaults.standard.bool(forKey: toggleNotiKey)
    }
    
    func onToggle(_ toggle: Bool) {
        self.toggleNotiStatus = toggle
        checkAuthorization()
        if self.toggleNotiStatus {
            switch (self.localNotiStatus) {
            case 0:
                requestAuthorization()
            case 1:
                scheduleNotification()
            default:
                return
            }
        } else {
            cancelNotification()
        }
    }
    
    func checkAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if (settings.authorizationStatus == .authorized) {
                DispatchQueue.main.async {
                    self.localNotiStatus = 1
                }
            } else if (settings.authorizationStatus == .denied) {
                DispatchQueue.main.async {
                    self.localNotiStatus = -1
                }
            }
        }
    }
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if (settings.authorizationStatus == .authorized) {
                print("Notification Permission is authorized");
            } else if (settings.authorizationStatus == .denied){
                print("Notification Permission is denied");
            }
            else {
                UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
                    if (success) {
                        DispatchQueue.main.async {
                            self.localNotiStatus = 1
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.localNotiStatus = -1
                        }
                    }
                    if let error = error {
                        print("ERROR \(error)")
                    } else {
                        print("SUCCESS \(success)")
                    }
                }
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "This is my first notification!"
        content.subtitle = "This was soooo easy!"
        content.body = "This is body of notification."
        content.sound = .default
        content.badge = 1
        
        //time-interval
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //calendar
        var dateComponent = DateComponents()
        dateComponent.hour = 9
        dateComponent.minute = 47
        //                dateComponent.weekday = 2 //Every Monday (1: Sunday)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func goToSetting() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) { success in
            print("Settings opened: \(success)") // Prints true
        }
    }
}
