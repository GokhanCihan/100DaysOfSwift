//
//  ViewController.swift
//  Project21-Local-Notifications
//
//  Created by Gökhan on 16.09.2022.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    var timeIntervalForTrigger = Int()
    var content = UNMutableNotificationContent()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(register))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    @objc func register() {
        let center = UNUserNotificationCenter.current()
        
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
        content.title = "Content's Title"
        content.body = "Content's Body"
        
        //should be the same string with identifier of UNNotificationCategory in registerCategories()
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "asdmadsfjks"]
        content.sound = UNNotificationSound.default
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        //multiple UNNotificationActions can be created for one category
        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let reminder = UNNotificationAction(identifier:"reminder" , title: "Remind me later", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, reminder], intentIdentifiers: [])

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
                let ac = UIAlertController(title: "Custom Data", message: "\(customData)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                
                present(ac, animated: true)

            case "show":
                // the user tapped our "show more info…" button
                let ac = UIAlertController(title: "More Information", message: "Displaying more information...", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                
                present(ac, animated: true)
                
            case "reminder":
                let triggerTomorrow = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
                let requestTomorrow = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: triggerTomorrow)
                
                center.add(requestTomorrow)

            default:
                break
            }
        }

        // you must call the completion handler when you're done
        completionHandler()
    }
}

