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
    private let playerViewController = AVPlayerViewController() // i use AVFoundation and AVKit for playing this video
    
    private let avPlayer = AVPlayer()
    
    private lazy var playerView: UIView = {
        let view = playerViewController.view!
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @Published private var playing = false
    
    public init() {}
    
    public func add(to view: UIView) { // get a view parameter from ViewController class and add this view into the playerView
        playerView.layer.cornerRadius = 20
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
        playing = true
    }
    
    public func pause() {
        if playing {
            avPlayer.pause()
            playing = false
        } else {
            avPlayer.play()
        }
        playing.toggle()
    }
    
      
}
