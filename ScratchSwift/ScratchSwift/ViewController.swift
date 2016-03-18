//
//  ViewController.swift
//  ScratchSwift
//
//  Created by Rohit Singh on 04/04/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScratchView(frame: CGRectMake(00, 00, 320, 1222))
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

