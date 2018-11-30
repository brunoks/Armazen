//
//  CustomTabBarController.swift
//  ProjectChat
//
//  Created by Luciano Pezzin on 21/11/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tableView = ViewController()
        tableView.view.backgroundColor = .white
        let chatMessage = UINavigationController(rootViewController: tableView)
        chatMessage.tabBarItem.title = "Recent"
        chatMessage.tabBarItem.image = UIImage(named: "recent")
        
        viewControllers = [
            chatMessage,
            createDummyNavController(title: "Calls", imageName: "calls"),
            createDummyNavController(title: "Groups", imageName: "groups"),
            createDummyNavController(title: "People", imageName: "people"),
            createDummyNavController(title: "Settings", imageName: "settings")
        ]
    }
    private func createDummyNavController(title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
