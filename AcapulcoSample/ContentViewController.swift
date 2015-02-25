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
    
    public var URL : NSURL?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSURLRequest(URL: URL!)
        
        webView?.loadRequest(request)
    }
}
