//
//  AppDelegate.swift
//  Absensi
//
//  Created by I putu Rama anadya on 15/10/23.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        registerForNotification()
        return true
    }
    
    func registerForNotification() {
        //For device token and push notifications.
        UIApplication.shared.registerForRemoteNotifications()
        
        let center : UNUserNotificationCenter = UNUserNotificationCenter.current()
        //        center.delegate = self
        
        center.requestAuthorization(options: [.sound , .alert , .badge ], completionHandler: { (granted, error) in
            if ((error != nil)) { UIApplication.shared.registerForRemoteNotifications() }
            else {
                
            }
        })
    }
}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("\nFCM GET DEVICE TOKEN: \(deviceToken)\n\n")
//        Messaging.messaging().apnsToken = deviceToken
//    }


    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcm = Messaging.messaging().fcmToken {
            print("FCM TOKEN: ", fcm)
            UserSettings.shared.setFCMToken(token: fcm)
        } else {
            print("\nFCM TOKEN NOT FOUND\n\n")
        }
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                  willPresent notification: UNNotification) async
//        -> UNNotificationPresentationOptions {
//        let userInfo = notification.request.content.userInfo
//        print("\nNotification Received in foreground\n")
//        print(userInfo)
//        print("\n")
//            return [[.alert, .sound, .badge, .banner]]
//      }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("\nNotification Received in foreground\n")
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        print("\n")
        completionHandler([.badge, .banner, .sound])
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
      -> UIBackgroundFetchResult {
      print(userInfo)

      return UIBackgroundFetchResult.newData
    }
}
