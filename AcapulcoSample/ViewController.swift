//
//  ViewController.swift
//  AcapulcoSample
//
//  Created by Nicolo' on 25/02/15.
//  Copyright (c) 2015 Dimension s.r.l. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Acapulco.sharedInstance.registerCallback({
            (userInfo:[NSObject : AnyObject]) in
            
            if let aps = userInfo["aps"] as? NSDictionary,
             let contentAvailable = aps["content-available"] as? Int,
                let url = userInfo["url"] as? String {
                
                    if let URL = NSURL(string: url) {
                        self.showModalViewController(URL)
                                        return true
                    }
            }
            
            return false
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showModalViewController(URL:NSURL) {
        
        let controller : ContentViewController = UIStoryboard(name: "Acapulco", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("ContentVC") as! ContentViewController
        controller.URL = URL
        controller.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        presentViewController(controller, animated: true, completion: nil)
    }
}

