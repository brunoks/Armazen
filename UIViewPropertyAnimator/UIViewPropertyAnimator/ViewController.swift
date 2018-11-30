//
//  ViewController.swift
//  UIViewPropertyAnimator
//
//  Created by Luciano Pezzin on 01/11/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let imageView = UIImageView(image: #imageLiteral(resourceName: "natu"))

    let visualEffectView = UIVisualEffectView(effect: nil)
    
    let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        
        setupVisualBlurEffectView()
        
        setupSlider()
        
        animator.addAnimations {
            
            self.imageView.transform = CGAffineTransform(scaleX: 4, y: 4)
            self.visualEffectView.effect = UIBlurEffect(style: .regular)
        }
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    fileprivate func setupVisualBlurEffectView() {
        view.addSubview(visualEffectView)
        visualEffectView.fillSuperview()
    }
    fileprivate func setupSlider() {
        let slider = UISlider()
        view.addSubview(slider)
        slider.anchor(top: imageView.bottomAnchor, leading: imageView.leadingAnchor, bottom: nil, trailing: imageView.trailingAnchor)
        slider.addTarget(self, action: #selector(handleSliderChange(slider:)), for: .valueChanged)
    }
    @objc fileprivate func handleSliderChange(slider: UISlider) {
        print(slider.value)
        animator.fractionComplete = CGFloat(slider.value)
    }
    @objc func handleTap() {
        imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    fileprivate func setupImageView() {
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.centerInSuperview(size: .init(width: 200, height: 200))
    }
}

