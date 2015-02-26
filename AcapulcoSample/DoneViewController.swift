//
//  DoneViewController.swift
//  AcapulcoSample
//
//  Created by Nicolo' on 26/02/15.
//  Copyright (c) 2015 Dimension s.r.l. All rights reserved.
//

import UIKit

public class DoneViewController: UIViewController {

    @IBAction public func actionDone() {
        
        // Tell the navigation controller to dimiss itself and take its child with him
        self.navigationController?.dismissViewControllerAnimated(true, completion: {
            
            println("Thank you!") // Log something nice for once :)
        })
    }
}
