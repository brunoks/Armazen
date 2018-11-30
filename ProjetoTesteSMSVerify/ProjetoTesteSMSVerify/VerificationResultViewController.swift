//
//  VerificationResultViewController.swift
//  ProjetoTesteSMSVerify
//
//  Created by Luciano Pezzin on 13/11/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit

class VerificationResultViewController: UIViewController {

    @IBOutlet var successIndication: UILabel! = UILabel()
    
    var message: String?
    
    override func viewDidLoad() {
        if let resultToDisplay = message {
            successIndication.text = resultToDisplay
        } else {
            successIndication.text = "Something went wrong!"
        }
        super.viewDidLoad()
    }
}
