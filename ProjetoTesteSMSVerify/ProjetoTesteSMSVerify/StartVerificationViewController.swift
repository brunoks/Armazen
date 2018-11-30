//
//  StartVerificationViewController.swift
//  ProjetoTesteSMSVerify
//
//  Created by Luciano Pezzin on 13/11/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit

class StartVerificationViewController: UIViewController {

    @IBOutlet var phoneNUmberField: UITextField! = UITextField()
    @IBOutlet var countryCodeField: UITextField! = UITextField()
    
    @IBAction func sendVerification() {
        if let phoneNumber = phoneNUmberField.text,
            let countryCode = countryCodeField.text {
            VerifyAPI.sendVerificationCode(countryCode, phoneNumber)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? CheckVerificationViewController {
            dest.countryCode = countryCodeField.text
            dest.phoneNumber = phoneNUmberField.text
        }
    }
}
