//
//  ViewController.swift
//  crashteste
//
//  Created by Luciano Pezzin on 02/10/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit
import Crashlytics
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)

    }

    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }

}

