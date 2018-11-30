//
//  Exemplos.swift
//  
//
//  Created by Luciano Pezzin on 30/11/2018.
//

import UIKit
import CNMutableContact

let newContact = CNMutableContact()
newContact.phoneNumbers.append(CNLabeledValue(label: "home", value: CNPhoneNumber(stringValue: "123456")))
let contactVC = CNContactViewController(forUnknownContact: newContact)
contactVC.contactStore = CNContactStore()
contactVC.delegate = self
contactVC.allowsActions = false
let navigationController = UINavigationController(rootViewController: contactVC) //For presenting the vc you have to make it navigation controller otherwise it will not work, if you already have navigatiation controllerjust push it you dont have to make it a navigation controller
self.present(navigationController, animated: true, completion: nil)
