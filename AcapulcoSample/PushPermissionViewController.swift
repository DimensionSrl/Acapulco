//
//  PushPermissionViewController.swift
//  AcapulcoSample
//
//  Created by Nicolo' on 26/02/15.
//  Copyright (c) 2015 Dimension s.r.l. All rights reserved.
//

import UIKit

public class PushPermissionViewController : UIViewController {
    
    @IBAction public func actionAskPermission() {
     
        // Attempt to enable push notifications
        let types : UIUserNotificationType = [.Badge, .Sound, .Alert]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        print("I just asked to enabled Push Notifications")
        
        performSegueWithIdentifier("toThanks", sender: self) // Peform the "toThanks" segue in the storyboard
    }
}
