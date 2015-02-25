//
//  Acapulco.swift
//  AcapulcoSample
//
//  Created by Nicolo' on 25/02/15.
//  Copyright (c) 2015 Dimension s.r.l. All rights reserved.
//

import Foundation
import UIKit

// This will take care of APNS in your place.
public class Acapulco {
    
    struct AcapulcoConstants {
        static let ServerAddressKey = "acapulcoServerAddress"
        static let RegistrationIdKey = "acapulcoRegistrationId"
        static let ApplicationKeyKey = "acapulcoApplicationKey"
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
    
    private func updateRegistration(registrationId: String, serverAddress: String, applicationKey: String) {
        NSUserDefaults.standardUserDefaults().setObject(serverAddress, forKey: AcapulcoConstants.ServerAddressKey)
        NSUserDefaults.standardUserDefaults().setObject(registrationId, forKey: AcapulcoConstants.RegistrationIdKey)
        NSUserDefaults.standardUserDefaults().setObject(applicationKey, forKey: AcapulcoConstants.ApplicationKeyKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    public func handleNotification(userInfo: [NSObject : AnyObject]) -> Bool {
        
        let notification : NSDictionary = userInfo
        
        println(notification.description)
        
        return false
    }
    
    /**
        This will update some of the device data on Acapulco.
    
    :serverAddress: The address of Acapulco.
    
    :applicationKey: The application key you got from Acapulco.
    
    */
    public func updateDeviceInfo() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let registrationId = userDefaults.objectForKey(AcapulcoConstants.RegistrationIdKey) as? String,
            let address = userDefaults.objectForKey(AcapulcoConstants.ServerAddressKey) as? String,
            let key = userDefaults.objectForKey(AcapulcoConstants.ApplicationKeyKey) as? String {
            register(registrationId, serverAddress: address, applicationKey: key)
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
        request.timeoutInterval = 5
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
            
            if (error == nil) {
                
                var error :NSErrorPointer = nil
                if let response = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: error) as? NSDictionary, let registrationId = response["id"] as? String {
                    self.updateRegistration(registrationId, serverAddress: serverAddress, applicationKey: applicationKey)
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
    
    /**
        Tell Acapulco to register itself onto the server. You must set both
    the serverAddress and the applicationToken by the time you call this method.
    
    :apnsToken: The token you got back when you registered on the APNS.
    
    :serverAddress: The address of Acapulco.
    
    :applicationKey: The application key you got from Acapulco.
    */
    public func register(apnsToken token: NSData, serverAddress: String, applicationKey: String) {
        
        let tokenString = convertTokenDataToHexString(token)
        
        register(tokenString, serverAddress: serverAddress, applicationKey: applicationKey)
    }
}