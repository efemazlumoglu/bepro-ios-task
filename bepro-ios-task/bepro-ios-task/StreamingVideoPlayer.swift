//
//  StreamingVideoPlayer.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 19.03.2022.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

public class StreamingVideoPlayer {
    public let playerViewController = AVPlayerViewController() // i use AVFoundation and AVKit for playing this video
    
    public let avPlayer = AVPlayer()
    
    public lazy var playerView: UIView = {
        let view = playerViewController.view!
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var t1: Float = 0.0
    var t2: Float = 0.0
    var currentSeconds: Float = 0.0
    
    public init() {}
    
    public func add(to view: UIView) { // get a view parameter from ViewController class and add this view into the playerView
        view.addSubview(playerView)
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: view.topAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    public func play(url: URL) { // to work with m3u file extensions you have to use AVAsset otherwise it will not work or i did not know how to implement :)
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        avPlayer.replaceCurrentItem(with: playerItem)
        playerViewController.player = avPlayer
        playerViewController.player?.play()
    }
    
    public func playPause() {
        avPlayer.seek(to: CMTime(seconds: Double(self.currentSeconds), preferredTimescale: .max))
        avPlayer.play()
    }
    
    public func pause() {
        avPlayer.pause()
        self.t1 = Float(avPlayer.currentTime().value)
        self.t2 = Float(avPlayer.currentTime().timescale)
        self.currentSeconds = t1 / t2
    }
    
      
}
