//
//  ContentViewController.swift
//  AcapulcoSample
//
//  Created by Nicolo' on 25/02/15.
//  Copyright (c) 2015 Dimension s.r.l. All rights reserved.
//

import UIKit

public class ContentViewController : UIViewController {
    
    @IBOutlet weak var webView: UIWebView?
    @IBOutlet weak var debugButton: UIBarButtonItem!
    
    var debug : Bool = false {
        didSet {
            updateUserInfo()
        }
    }
    
    @IBAction public func actionDone(sender:AnyObject?) {
        
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction public func actionDebug(sender:AnyObject?) {
        self.debug = !debug
    }
    
    public var userInfo : NSObject? {
        didSet {
            updateUserInfo()
        }
    }
    
    private func updateUserInfo() {
        
        if let payload = userInfo as? NSDictionary {
            
            Acapulco.sharedInstance.didRedNotification(userInfo as! [NSObject : AnyObject])
            
            if debug { // Show raw notification data

                let content = payload.description // Just take the description...
                
                let htmlString = "<html><body>" + content + "</body></html>" // ... and dump it in the body of the HTML page
                
                webView?.loadHTMLString(htmlString, baseURL: nil) // Show the HTML page
                
            } else { // Attemp to load the URL
                
                if let urlString = payload["url"] as? String {
                    
                    if let URL = NSURL(string: urlString) {
                        let request = NSURLRequest(URL: URL)
                        webView?.loadRequest(request)
                    }
                } else {
                    
                }
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        updateUserInfo()
    }
}
