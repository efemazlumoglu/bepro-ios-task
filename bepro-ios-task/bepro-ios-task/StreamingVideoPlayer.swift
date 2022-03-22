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
        playerViewController.showsPlaybackControls = true   // i add this line for the playback controls of the videoPlayer it self
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
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil) // did play to end time notification observer
    }
    
    public func playPause() { // this method is for playing where you have left in the video
        avPlayer.seek(to: CMTime(seconds: Double(self.currentSeconds), preferredTimescale: .max))
        avPlayer.play()
    }
    
    public func pause() {
        avPlayer.pause()
        self.t1 = Float(avPlayer.currentTime().value)
        self.t2 = Float(avPlayer.currentTime().timescale)
        self.currentSeconds = t1 / t2 // to get the currentSeconds cause i need to seek that time when you play it again
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification){
        NotificationCenter.default.post(name: Notification.Name("PlayingFinished"), object: nil) // post the notif to the view controller
    }
      
}
