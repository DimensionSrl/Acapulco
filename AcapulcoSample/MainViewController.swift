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

        if let URL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("README", ofType: "html")!) {
            let request = NSURLRequest(URL: URL)
            if let webView = view as? UIWebView {
                webView.loadRequest(request)
            }
        }
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check if we have already registered on Acapulco. If not, 
        // start the registration flow
        if !(Acapulco.sharedInstance.isRegistered()) {
            println("Acapulco is not registered, yet")
            performSegueWithIdentifier("registration", sender: self)
        } else {
            println("Acapulco is already registered")
        }
        
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

