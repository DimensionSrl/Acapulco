//
//  AppDelegate.swift
//  AcapulcoSample
//
//  Created by Nicolo' on 25/02/15.
//  Copyright (c) 2015 Dimension s.r.l. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        Acapulco.sharedInstance.didReceiveNotification(userInfo)
        
        let notification = NotificationFactory.PushReceivedNotification(userInfo)
        NSNotificationCenter.defaultCenter().postNotification(notification) // Post the notification
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        Acapulco.sharedInstance.didReceiveNotification(userInfo)
        
        NSUserDefaults.standardUserDefaults().setObject(userInfo, forKey: "backgroundNotification") // Save the last notification for later user
        
        let notification = NotificationFactory.PushReceivedNotification(userInfo)
        NSNotificationCenter.defaultCenter().postNotification(notification) // Post the notification
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println(error.localizedDescription)
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        Acapulco.sharedInstance.registerAPNSToken(deviceToken, serverAddress:"acapulco.dimension.it", applicationKey: "8ef1bd2601579e98")
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
        if let backgroundNotification : NSObject = NSUserDefaults.standardUserDefaults().objectForKey("backgroundNotification") as? NSObject {
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("backgroundNotification") // We don't need it anymore
            
            let notification = NotificationFactory.PushReceivedNotification(backgroundNotification as! [NSObject : AnyObject])
            NSNotificationCenter.defaultCenter().postNotification(notification) // Post the notification
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Renew registration
        if Acapulco.sharedInstance.isRegistered() {
            let types : UIUserNotificationType = .Badge | .Sound | .Alert
            let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        }
        return true
    }
    
     func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
}

