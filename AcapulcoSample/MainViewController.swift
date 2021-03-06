//
//  ViewController.swift
//  AcapulcoSample
//
//  Created by Nicolo' on 25/02/15.
//  Copyright (c) 2015 Dimension s.r.l. All rights reserved.
//

import UIKit

public class MainViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Load the webview content
        let URL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("README", ofType: "html")!)
        let request = NSURLRequest(URL: URL)
        if let webView = view as? UIWebView {
            webView.loadRequest(request)
        }

        // Renew registrations to NSNotificationCenter
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleApplicationDidEnterBackgroundNotification:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleApplicationDidBecomeActiveNotification:", name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleNotification:", name: NotificationFactory.Names.PushReceivedNotificationName, object: nil)
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check if we have already registered on Acapulco. If not, 
        // start the registration flow
        if !(Acapulco.sharedInstance.isRegistered()) {
            print("Acapulco is not registered, yet")
            performSegueWithIdentifier("registration", sender: self)
        } else {
            print("Acapulco is already registered")
        }
    }
    
    public func handleApplicationDidEnterBackgroundNotification(notification: NSNotification) {
        
        // Stop accepting local notification while in background
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationFactory.Names.PushReceivedNotificationName, object: nil)
    }
    
    public func handleApplicationDidBecomeActiveNotification(notification: NSNotification) {
        
        // Resume handling local notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleNotification:", name: NotificationFactory.Names.PushReceivedNotificationName, object: nil)
    }
    
    public func handleNotification(notification: NSNotification) {
     
        if let userInfo = notification.object as? [NSObject : AnyObject] {
            
            if let navController = self.presentedViewController as? UINavigationController,
                let contentViewController = navController.viewControllers[0] as? ContentViewController {
                
                contentViewController.userInfo = userInfo
                
            } else {
                
                performSegueWithIdentifier("showContent", sender: userInfo) // We use the sender to pass the notification content
            }
        }
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let navController = segue.destinationViewController as? UINavigationController,
        let contentViewController = navController.viewControllers[0] as? ContentViewController {
            if let userInfo = sender as? [NSObject : AnyObject] {
                
                contentViewController.userInfo = userInfo
            }
        }
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

