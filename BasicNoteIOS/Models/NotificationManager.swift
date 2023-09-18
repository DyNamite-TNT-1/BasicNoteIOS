//
//  NotificationManager.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/18/23.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationManager {
    
    static let instance = NotificationManager() //singleton
    
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
                dateComponent.hour = 14
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
    
}
