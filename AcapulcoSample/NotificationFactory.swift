//
//  NotificationFactory.swift
//  AcapulcoSample
//
//  Created by Nicolo' on 26/02/15.
//  Copyright (c) 2015 Dimension s.r.l. All rights reserved.
//

import Foundation

/// Factory class to lessen the burden of writing NSNotification boilerplate code.
public class NotificationFactory {
    
    public struct Names {
       static let PushReceivedNotificationName : String = "PushReceivedNotification"
    }
    
    /**
        Given an userInfo dictionary, it returns an NSNotification named 
    PushReceivedNotification with the dictionary as object.
        :userInfo: The dictionary.
        :returns: The NSNotification
    */
    public class func PushReceivedNotification(userInfo:[NSObject : AnyObject]) -> NSNotification {
     
        let notification = NSNotification(name:Names.PushReceivedNotificationName, object:userInfo)
        return notification
    }
}