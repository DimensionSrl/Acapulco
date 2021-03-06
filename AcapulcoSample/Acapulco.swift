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
        
        if let notificationId = payload["id"] as? NSString {
                tellNotificationRed(notificationId.integerValue)
        }
    }
    
    /**
        Tell Acapulco you received the notification.
    
        :userInfo: The notification payload.
    */
    public func didReceiveNotification(userInfo:[NSObject : AnyObject]) {
        
        let payload = userInfo as NSDictionary
        
         if let notificationId = payload["id"] as? NSString {
                tellNotificationReceived(notificationId.integerValue)
        }
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
    
    private func tellNotificationRed(notificationId: Int, registrationId: String, serverAddress: String, applicationKey: String) {
        
        let nofificationIdString = String(format:"%d", notificationId)
        
        let url = NSURL(string: serverAddress)?.URLByAppendingPathComponent("apps").URLByAppendingPathComponent(applicationKey).URLByAppendingPathComponent("devices").URLByAppendingPathComponent(registrationId).URLByAppendingPathComponent("messages").URLByAppendingPathComponent(nofificationIdString).URLByAppendingPathComponent("red")
        
        let request = NSMutableURLRequest()
        request.URL = url
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = AcapulcoConstants.Timeout
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            if let data = data {
                print(NSString(data: data, encoding: NSUTF8StringEncoding))
            } else {
                print("Error \(error?.localizedDescription)")
            }
        }
        
        task.resume()
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
        
        let url = NSURL(string: serverAddress)?.URLByAppendingPathComponent("apps").URLByAppendingPathComponent(applicationKey).URLByAppendingPathComponent("devices").URLByAppendingPathComponent(registrationId).URLByAppendingPathComponent("messages").URLByAppendingPathComponent(nofificationIdString).URLByAppendingPathComponent("received")
        
        let request = NSMutableURLRequest()
        request.URL = url
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = AcapulcoConstants.Timeout
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            if let data = data {
                print(NSString(data: data, encoding: NSUTF8StringEncoding))
            } else {
                print("Error \(error?.localizedDescription)")
            }
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
    
    private func register(token: String, serverAddress: String, applicationKey: String) {
        
        let url = NSURL(string: serverAddress)?.URLByAppendingPathComponent("apps").URLByAppendingPathComponent(applicationKey).URLByAppendingPathComponent("devices")
        
        let request = NSMutableURLRequest()
        request.URL = url
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "POST"
        
        // TODO: get coordinates from CoreLocation
        // let lat = 46.0667
        // let lon = 11.1167
        let identifier = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let locale = "it"
        let name = UIDevice.currentDevice().name
        
        let payload = ["identifier":identifier,
            "token":token,
            // "lat":lat,
            // "lon":lon,
            "locale":locale,
            "name":name
        ]
        
        do {
            let jsonPayload = try NSJSONSerialization .dataWithJSONObject(payload, options: NSJSONWritingOptions())
            request.HTTPBody = jsonPayload
            request.timeoutInterval = AcapulcoConstants.Timeout
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                [weak self](data, response, error) in
                if let data = data {
                    print(NSString(data: data, encoding: NSUTF8StringEncoding))
                    if (error == nil) {
                        do {
                            if let response = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? NSDictionary, let registrationId = response["id"] as? String {
                                self?.updateRegistration(token, serverAddress: serverAddress, applicationKey: applicationKey, registrationId:registrationId)
                            }
                        } catch _ {
                            print("Cannot parse respose as Json")
                        }
                    } else {
                        print("Error \(error?.localizedDescription)")
                    }
                } else {
                    print("Not data in the response")
                }
            }
            task.resume()
        } catch _ {
            print("Error: cannot create payload")
        }
    }
    
    private func convertTokenDataToHexString(token: NSData) -> String {
        
        // Let's convert an NSData blob to its hex string representation
        
        let tokenString = token.description.stringByReplacingOccurrencesOfString("<", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString(">", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        return tokenString
    }
}