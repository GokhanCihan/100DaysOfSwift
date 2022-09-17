//
//  ViewController.swift
//  Project21-Local-Notifications
//
//  Created by Gökhan on 16.09.2022.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(register))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    @objc func register() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Heyo")
            } else {
                print("O-Oh")
            }
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        //registers to local
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        //Notification Content
        let content = UNMutableNotificationContent()
        content.title = "Content's Title"
        content.body = "Content's Body"
        content.categoryIdentifier = "customIdentifier"
        content.userInfo = ["customData": "asdmadsfjks"]
        content.sound = UNNotificationSound.default
        
        //Notification Trigger
        var dateComponents = DateComponents()
        dateComponents.hour = 22
        dateComponents.minute = 45
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])

        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo

        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")

            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")

            case "show":
                // the user tapped our "show more info…" button
                print("Show more information…")

            default:
                break
            }
        }

        // you must call the completion handler when you're done
        completionHandler()
    }
}

