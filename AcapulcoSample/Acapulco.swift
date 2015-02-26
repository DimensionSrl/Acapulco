//
//  Acapulco.swift
//  AcapulcoSample
//
//  Created by Nicolo' on 25/02/15.
//  Copyright (c) 2015 Dimension s.r.l. All rights reserved.
//

import Foundation
import UIKit

public typealias AcapulcoNotificationCallback = (userInfo: [NSObject : AnyObject]) -> Bool

// This will take care of APNS in your place.
public class Acapulco {
    
    struct AcapulcoConstants {
        static let ServerAddressKey = "acapulcoServerAddress"
        static let ApnsTokenKey = "acapulcoApnsToken"
        static let ApplicationKeyKey = "acapulcoApplicationKey"
        static let RegistrationIdKey = "acapulcoRegistrationIdKey"
        static let Timeout : NSTimeInterval = 5
    }
    
    /**
    Get the singleton. This is the only valid way to create an Acapulco instance.
    */
    public class var sharedInstance: Acapulco {
        struct SharedInstance  {
            static let instance = Acapulco()
        }
        return SharedInstance.instance
    }
    
    /**
    Tell Acapulco to register itself onto the server. You must set both
    the serverAddress and the applicationToken by the time you call this method.
    
    :token: The token you got back when you registered on the APNS.
    
    :serverAddress: The address of Acapulco.
    
    :applicationKey: The application key you got from Acapulco.
    */
    public func registerAPNSToken(token: NSData, serverAddress: String, applicationKey: String) {
        
        let tokenString = convertTokenDataToHexString(token)
        
        register(tokenString, serverAddress: serverAddress, applicationKey: applicationKey)
    }
    
    /**
        Tell you if this application has been already registered on Acapulco.
    
        :returns: true if already registered, otherwise false.
    */
    public func isRegistered() -> Bool {
        
        return NSUserDefaults.standardUserDefaults().objectForKey(AcapulcoConstants.RegistrationIdKey) != nil
    }
    
    /**
        Tell Acapulco you red the notification.
    
        :userInfo: The notification payload.
    */
    public func didRedNotification(userInfo:[NSObject : AnyObject]) {
        
        let payload = userInfo as NSDictionary
        
        if let notificationId = payload["id"] as? Int {
                tellNotificationReceived(notificationId)
        }
    }
    
    /**
        Tell Acapulco you received the notification.
    
        :userInfo: The notification payload.
    */
    public func didReceiveNotification(userInfo:[NSObject : AnyObject]) {
        
        let payload = userInfo as NSDictionary
        
         if let notificationId = payload["id"] as? Int {
                tellNotificationReceived(notificationId)
        }
    }
    
    private func tellNotificationRed(notificationId: Int, registrationId: String, serverAddress: String, applicationKey: String) {
        
        let nofificationIdString = String(format:"%d", notificationId)
        let path = "http://" + serverAddress.stringByAppendingPathComponent("apps").stringByAppendingPathComponent(applicationKey).stringByAppendingPathComponent("devices").stringByAppendingPathComponent(registrationId).stringByAppendingPathComponent("messages").stringByAppendingPathComponent(nofificationIdString).stringByAppendingPathComponent("red")
        
        let url = NSURL(string: path)
        
        let request = NSMutableURLRequest()
        request.URL = url
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = AcapulcoConstants.Timeout
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        
        task.resume()
    }
    
    private var callbacks = [AcapulcoNotificationCallback]()
    
    public func registerCallback(callback: AcapulcoNotificationCallback) {
        callbacks.append(callback)
    }
    
    private func tellNotificationRed(notificationId: Int) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        // We need the registration ID, the server address and the application key
        
        if let registrationId = userDefaults.objectForKey(AcapulcoConstants.RegistrationIdKey) as? String,
            let address = userDefaults.objectForKey(AcapulcoConstants.ServerAddressKey) as? String,
            let key = userDefaults.objectForKey(AcapulcoConstants.ApplicationKeyKey) as? String {
                tellNotificationRed(notificationId, registrationId: registrationId, serverAddress: address, applicationKey: key)
        }
    }
    
    private func tellNotificationReceived(notificationId: Int, registrationId: String, serverAddress: String, applicationKey: String) {
        
        let nofificationIdString = String(format:"%d", notificationId)
        let path = "http://" + serverAddress.stringByAppendingPathComponent("apps").stringByAppendingPathComponent(applicationKey).stringByAppendingPathComponent("devices").stringByAppendingPathComponent(registrationId).stringByAppendingPathComponent("messages").stringByAppendingPathComponent(nofificationIdString).stringByAppendingPathComponent("received")
        
        let url = NSURL(string: path)
        
        let request = NSMutableURLRequest()
        request.URL = url
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = AcapulcoConstants.Timeout
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        
        task.resume()
    }
    
    private func tellNotificationReceived(notificationId: Int) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()

        // We need the registration ID, the server address and the application key
        
        if let registrationId = userDefaults.objectForKey(AcapulcoConstants.RegistrationIdKey) as? String,
            let address = userDefaults.objectForKey(AcapulcoConstants.ServerAddressKey) as? String,
            let key = userDefaults.objectForKey(AcapulcoConstants.ApplicationKeyKey) as? String {
                tellNotificationReceived(notificationId, registrationId: registrationId, serverAddress: address, applicationKey: key)
        }
    }
    
    private func updateRegistration(apnsToken: String, serverAddress: String, applicationKey: String,registrationId: String) {
        
        NSUserDefaults.standardUserDefaults().setObject(serverAddress, forKey: AcapulcoConstants.ServerAddressKey)
        NSUserDefaults.standardUserDefaults().setObject(apnsToken, forKey: AcapulcoConstants.ApnsTokenKey)
        NSUserDefaults.standardUserDefaults().setObject(applicationKey, forKey: AcapulcoConstants.ApplicationKeyKey)
        NSUserDefaults.standardUserDefaults().setObject(registrationId, forKey: AcapulcoConstants.RegistrationIdKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    public func handleNotification(userInfo: [NSObject : AnyObject]) -> Bool {
        
        let notification : NSDictionary = userInfo
        
        println(notification.description)
        
        if notification["id"] != nil {
         
            let notificationId = notification["id"]?.integerValue
            
            if (notificationId != nil) {
                tellNotificationReceived(notificationId!)
            }
            
            for callback in callbacks {
                
                if callback(userInfo: userInfo) {
                    tellNotificationRed(notificationId!)
                }
            }
            
            return true
        }
        
        return false
    }
    
    /**
        This will update some of the device data on Acapulco.
    
    :serverAddress: The address of Acapulco.
    
    :applicationKey: The application key you got from Acapulco.
    
    */
    public func updateDeviceInfo() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        // We need the apns token, the server address and the application key
        if let apnsToken = userDefaults.objectForKey(AcapulcoConstants.ApnsTokenKey) as? String,
            let address = userDefaults.objectForKey(AcapulcoConstants.ServerAddressKey) as? String,
            let key = userDefaults.objectForKey(AcapulcoConstants.ApplicationKeyKey) as? String {
            register(apnsToken, serverAddress: address, applicationKey: key)
        }
    }
    
    private func register(token: String, serverAddress: String, applicationKey: String) {
        
        let path = "http://" + serverAddress.stringByAppendingPathComponent("apps").stringByAppendingPathComponent(applicationKey).stringByAppendingPathComponent("devices")
        
        let url = NSURL(string: path)
        
        let request = NSMutableURLRequest()
        request.URL = url
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "POST"
        
        // TODO: get coordinates from CoreLocation
        let lat = 46.0667
        let lon = 11.1167
        let identifier = UIDevice.currentDevice().identifierForVendor.UUIDString
        let locale = "it"
        let name = UIDevice.currentDevice().name
        
        let payload = ["identifier":identifier,
            "token":token,
            "lat":lat,
            "lon":lon,
            "locale":locale,
            "name":name
        ]
        
        var error :NSErrorPointer = nil
        let jsonPayload = NSJSONSerialization .dataWithJSONObject(payload, options: NSJSONWritingOptions.allZeros, error: error)
        request.HTTPBody = jsonPayload
        request.timeoutInterval = AcapulcoConstants.Timeout
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            [weak self](data, response, error) in
            
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
            
            if (error == nil) {
                
                var error :NSErrorPointer = nil
                if let response = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: error) as? NSDictionary, let registrationId = response["id"] as? String {
                    self?.updateRegistration(token, serverAddress: serverAddress, applicationKey: applicationKey, registrationId:registrationId)
                }
            } else {
                
            }
        }
        task.resume()
    }
    
    private func convertTokenDataToHexString(token: NSData) -> String {
        
        // Let's convert an NSData blob to its hex string representation
        
        let tokenString = token.description.stringByReplacingOccurrencesOfString("<", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString(">", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        return tokenString
    }
}