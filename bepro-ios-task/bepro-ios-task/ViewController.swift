//
//  ViewController.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 18.03.2022.
//

import UIKit
import Foundation
import AVFoundation

class ViewController: UIViewController {
    
    var matchId: Int = 0
    var videoUrl: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // match id fetch
        // video url fetch
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let videoURL = URL(string: "\(self.videoUrl)")
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
//        player.play()
    }


}

