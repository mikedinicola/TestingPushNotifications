//
//  MainViewController.swift
//  TestingPushNotifications
//
//  Created by Nicolás García on 04-01-18.
//  Copyright © 2018 Nicolas Garcia. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

final class MainViewController: UIViewController {
    
    @IBOutlet var notificationsButton: UIButton!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var sendWithoutCategoryButton: UIButton!
    @IBOutlet var sendInputButton: UIButton!
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    var deviceTokenLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsButton.accessibilityIdentifier = "notificationsButton"

        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.handleNotification(_:)), name: didRegisterWithDeviceTokenNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.handleNotification(_:)), name: bikeTheftNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.handleNotification(_:)), name: didTapOnActionNotification, object: nil)

    }
    
    @IBAction func remoteNotificationsAuthorization(_ sender: UIButton) {
        userNotificationCenter.requestAuthorization(options: [.alert, .sound]) {
            (granted, error) in
            guard granted else { return }
            
            self.getNotificationSettings()
        }
    }
    
    func sendNotification(_ category: String? = nil, latitude: Double? = nil, longitude: Double? = nil) {
        
        let triggerTime = TimeInterval(2)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerTime, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.body = "Your bike was stolen!"
        content.sound = .default()
        
        if let category = category {
            content.categoryIdentifier = category
        }
        if let latitude = latitude,
            let longitude = longitude {
            content.userInfo = [:]
            content.userInfo[latitude]  = latitude
            content.userInfo[longitude] = longitude
        }
        
        let uuidString = UUID().uuidString
        let notif = UNNotificationRequest(identifier: uuidString,
                                          content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(notif, withCompletionHandler: nil)
    }
    
    @IBAction func sendNotificationTouchUpInside(_ sender: Any) {
        
        let latitude = 47.2256013
        let longitude = -1.5633523
        
        sendNotification("notificationCategory", latitude: latitude, longitude: longitude)
    }
    
    @IBAction func sendInputNotificationTouchUpInside(_ sender: Any) {
        
        sendNotification("notificationTextInputCategory")
    }
    
    @IBAction func sendNotificationWithoutCategoryTouchUpInside(_ sender: Any) {
        
        let latitude = 47.2256013
        let longitude = -1.5633523
        
        sendNotification(latitude: latitude, longitude: longitude)
    }
    
    func getNotificationSettings() {
        userNotificationCenter.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    /*
     NSNotification allows us to access notificacion's name and object properties.
    */
    @objc func handleNotification(_ notification: NSNotification) {
        
        switch notification.name {
        case didRegisterWithDeviceTokenNotification:
            guard let deviceToken = notification.object as? String else {
                return
            }
            
        case bikeTheftNotification:
            guard let payload = notification.object as? [AnyHashable: Any],
            let latitude = payload["latitude"] as? Double,
            let longitude = payload["longitude"] as? Double else {
                return
            }
            
            let locationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let storyboard = UIStoryboard(name: "Theft", bundle: nil)
            let theftViewController = storyboard.instantiateViewController(withIdentifier: "TheftViewController") as! TheftViewController
            self.present(theftViewController, animated: true, completion: {
                theftViewController.locationCoordinate2D = locationCoordinate2D
            })
            
        case didTapOnActionNotification:
            let alert = UIAlertController(title: "Bonjour !", message: "You just tapped on the notification's action button", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
        default:
            break
        }
        
    }

}
