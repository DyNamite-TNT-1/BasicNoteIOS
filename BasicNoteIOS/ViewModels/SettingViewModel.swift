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
            saveData()
        }
    }
    
    @Published var toggleNotiStatus: Bool = false {
        didSet {
            saveData()
        }
    }
    
    let localNotiKey:String = "localNotiKey"
    let toggleNotiKey: String = "toggleNotiKey"
    
    var notificationManager = NotificationManager.instance
    
    init(){
        getData()
    }
    
    func getData() {
        localNotiStatus = UserDefaults.standard.integer(forKey: localNotiKey)
        toggleNotiStatus = UserDefaults.standard.bool(forKey: toggleNotiKey)
    }
    
    func saveData() {
        UserDefaults.standard.set(localNotiStatus, forKey: localNotiKey)
        UserDefaults.standard.set(toggleNotiStatus, forKey: toggleNotiKey)
    }
    
    func onToggle(_ toggle: Bool) {
//        checkAuthorization()
        print("1-")
        if toggle {
            print(self.localNotiStatus)
            switch (self.localNotiStatus) {
            case 0:
                requestAuthorization()
            case 1:
                scheduleNotification()
            default:
                requestAuthorization()
            }
        } else {
            cancelNotification()
        }
    }
    
    func checkAuthorization() {
        var check: Bool = false
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if (settings.authorizationStatus == .authorized) {
                print(2)
                check = true
            } else if (settings.authorizationStatus == .denied) {
                check = false
            }
        }
        print(check)
        if (check) {
            print(3)
            self.localNotiStatus = 1
        } else{
            self.localNotiStatus = -1
        }
    }
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if (settings.authorizationStatus == .authorized) {
                print("Notification Permission is authorized");
            } else if (settings.authorizationStatus == .denied){
                print("Notification Permission is denied");
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) { success in
                    print("Settings opened: \(success)") // Prints true
                }
            }
            else {
                UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
                    if (success) {
                        self.localNotiStatus = 1
                    } else {
                        self.localNotiStatus = -1
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
        print("schedule notification")
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
        dateComponent.hour = 12
        dateComponent.minute = 01
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
