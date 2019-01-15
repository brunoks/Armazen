//
//  ViewController.swift
//  GenericTableViewController
//
//  Created by Luciano Pezzin on 10/12/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit


class ExampleTableViewController: BaseTableViewController<ExampleCell,ExampleModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = [
            ExampleModel(name: "Bruno Vieira"),
            ExampleModel(name: "Edney"),
            ExampleModel(name: "Luciano Pezzin"),
            ExampleModel(name: "Rodrigo Oliveira")
        ]
    }
}


struct ExampleModel {
    let name: String
}

class ExampleCell: BaseCell<ExampleModel> {
    override var item: ExampleModel! {
        didSet {
            textLabel?.text = item.name
        }
    }
}
