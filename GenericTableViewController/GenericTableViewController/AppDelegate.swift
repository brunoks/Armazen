//
//  AppDelegate.swift
//  GenericTableViewController
//
//  Created by Luciano Pezzin on 10/12/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        window?.rootViewController = ExampleTableViewController()
        return true
    }

}

