//
//  ViewController.swift
//  RadioTeste
//
//  Created by Luciano Pezzin on 23/10/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    
    //http://streaming.radionomy.com/Elium-ClubDance
    let url = URL(string: "http://31.14.40.241:6184/")//"http://streaming.radionomy.com/Elium-ClubDance")
    
    var player = AVPlayer()
    var playerItem: AVPlayerItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNowPlaying()
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playbtnPause), for: .touchUpInside)
        self.view.addSubview(button)

        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        let pause = UIButton()
        pause.setTitle("Pause", for: .normal)
        pause.setTitleColor(UIColor.gray, for: .normal)
        pause.translatesAutoresizingMaskIntoConstraints = false
        pause.addTarget(self, action: #selector(pausebtn), for: .touchUpInside)
        self.view.addSubview(pause)
        
        pause.heightAnchor.constraint(equalToConstant: 35).isActive = true
        pause.widthAnchor.constraint(equalToConstant: 100).isActive = true
        pause.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -15).isActive = true
        pause.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        
        let go = UIButton()
        go.setTitle("Go", for: .normal)
        go.setTitleColor(UIColor.gray, for: .normal)
        go.translatesAutoresizingMaskIntoConstraints = false
        go.addTarget(self, action: #selector(goto), for: .touchUpInside)
        self.view.addSubview(go)
        
        go.heightAnchor.constraint(equalToConstant: 35).isActive = true
        go.widthAnchor.constraint(equalToConstant: 100).isActive = true
        go.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 15).isActive = true
        go.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true


        
        self.playerItem = AVPlayerItem(url: url!)
        self.player = AVPlayer(playerItem: playerItem)
        player.volume = 1.0
        setupRemoteTransportControls()
    }
    @objc func goto() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "teste")
        self.present(vc!, animated: true, completion: nil)
    }
    @objc func playbtnPause() {
        self.setupNowPlaying()
        player.play()
    }
    @objc func pausebtn() {
        
        player.pause()
    }
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player.rate == 0.0 {
                self.player.play()
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player.rate == 1.0 {
                self.player.pause()
                return .success
            }
            return .commandFailed
        }
    }
    func setupNowPlaying() {
        
        // ======== respond to remote controls
        
        var opaques = [String:Any]()
        
        
            let scc = MPRemoteCommandCenter.shared()
                scc.togglePlayPauseCommand.addTarget(self, action: #selector(doPlayPause))
                scc.playCommand.addTarget(self, action:#selector(doPlay))
                scc.pauseCommand.addTarget(self, action:#selector(doPause))
                // fun fun fun
                scc.likeCommand.addTarget(self, action:#selector(doLike))
                scc.likeCommand.localizedTitle = "Fantastic"

        }
    @objc func doPlayPause(_ event:MPRemoteCommandEvent) {
        print("playpause")
        
    }
    @objc func doPlay(_ event:MPRemoteCommandEvent) {
        print("play")
        self.player.play()
    }
    @objc func doPause(_ event:MPRemoteCommandEvent) {
        print("pause")
        self.player.pause()
    }
    @objc func doLike(_ event:MPRemoteCommandEvent) {
        print("like")
    }
}

