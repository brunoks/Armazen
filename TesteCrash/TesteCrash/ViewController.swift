//
//  ViewController.swift
//  TesteCrash
//
//  Created by Luciano Pezzin on 29/10/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit
import Crashlytics
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func button(_ sender: Any) {
        Crashlytics.sharedInstance().crash()
    }
}

