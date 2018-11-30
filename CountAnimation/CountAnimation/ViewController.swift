//
//  ViewController.swift
//  CountAnimation
//
//  Created by Luciano Pezzin on 01/11/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let countingLabel: UILabel = {
        let label = UILabel()
        label.text = "1234"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 26)
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(countingLabel)
        countingLabel.frame = view.frame
        
        let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink.add(to: .main, forMode: .default)
        
        
    }
    
    var startValue: Double = 0
    let endValue: Double = 12000
    let animationDuration: Double = 1.5
    let animationStartdate = Date()
    @objc func handleUpdate() {
        let now = Date()
        
        let elapsedTime = now.timeIntervalSince(animationStartdate)
        
        if elapsedTime > animationDuration {
            self.countingLabel.text = "\(endValue)"
        } else {
            let percentage = elapsedTime / animationDuration
            let value = startValue + percentage * (endValue - startValue)
            self.countingLabel.text = "\(value)"
        }
//        self.countingLabel.text = "\(startValue)"
//        startValue += 1
//        if startValue > endValue {
//            startValue = endValue
//        }
    }

}

