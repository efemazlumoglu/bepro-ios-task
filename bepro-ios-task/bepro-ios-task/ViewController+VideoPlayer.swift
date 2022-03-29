//
//  ViewController+VideoPlayer.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 29.03.2022.
//

import Foundation
import UIKit
import AVFoundation

extension ViewController {
    // MARK: Playing Finished Selector.
    @objc func playingFinished() { // this is for second half is opening sequentially
        if ViewModel.shared.videoURL == "First Half" {
            var fileUrl = URL(string: ViewModel.shared.firstHalfVideoUrl)!
            ViewModel.shared.videoURL = "Second Half"
            fileUrl = URL(string: ViewModel.shared.secondHalfVideoUrl)!
            self.videoPlayer.play(url: fileUrl)
        }
    }
    
    //MARK: Progress View Changed
    @objc func progressViewChanged() {
        
        if let duration = videoPlayer.avPlayer.currentItem?.duration {
            
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(self.progressView.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            videoPlayer.avPlayer.seek(to: seekTime, completionHandler: {
                completed in
                //
            })
        }
    }
    
    //MARK: Play Tapped selector
    @objc func playTapped() {
        self.matchIdTextField.resignFirstResponder()
        if (ViewModel.shared.firstHalfVideoUrl == "" && ViewModel.shared.secondHalfVideoUrl == "") { // this condition is for not to send request again and again
            playButton.isUserInteractionEnabled = false
            pauseButton.isUserInteractionEnabled = true
            self.pauseButton.backgroundColor = UIColor.systemOrange.withAlphaComponent(1)
            self.playButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.4)
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            loadView() // i called this method to re render the view
        } else {
            self.pauseButton.backgroundColor = UIColor.systemOrange.withAlphaComponent(1)
            self.playButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.4)
            playButton.isUserInteractionEnabled = false
            pauseButton.isUserInteractionEnabled = true
            let t1 = Float(videoPlayer.avPlayer.currentTime().value)
            let t2 = Float(videoPlayer.avPlayer.currentTime().timescale)
            let currentSeconds = t1 / t2
            self.videoPlayer.playPause(cmTime: CMTime(seconds: Double(currentSeconds), preferredTimescale: .max)) // this method is for paused player to seek the where it is left in the video player as seconds.
        }
    }
    
    //MARK: PauseTapped Selector
    @objc func pauseTapped() {
        self.matchIdTextField.resignFirstResponder()
        videoPlayer.pause()
        self.playButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(1)
        self.pauseButton.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.4)
        playButton.isUserInteractionEnabled = true
        pauseButton.isUserInteractionEnabled = false
    }
    
    //MARK: Open Full Screen Selector
    @objc func openFullScreen() { // for opening in full screen mode i changed the interface orientation to landscape cause i did this functionality for that
        self.matchIdTextField.resignFirstResponder()
        UIView.setAnimationsEnabled(false)
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
    }
    
    //MARK: Next Tapped Function
    @objc func nextTapped() {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { // animation for next button changes
            self.nextButton.setTitle(">>>", for: .normal)
            self.nextButton.backgroundColor = .systemGray2.withAlphaComponent(0.5)
            self.nextButton.setTitleColor(.systemRed, for: .normal)
        }
        self.matchIdTextField.resignFirstResponder()
        guard let duration  = videoPlayer.avPlayer.currentItem?.duration else {
            return
        }
        let playerCurrentTime = CMTimeGetSeconds(videoPlayer.avPlayer.currentTime())
        let newTime = playerCurrentTime + seekDuration

        if newTime < CMTimeGetSeconds(duration) {

            let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            videoPlayer.avPlayer.seek(to: time2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { // that is used cause the screen show at least 1 second more.
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                    self.nextButton.setTitle("", for: .normal)
                    self.nextButton.backgroundColor = .white.withAlphaComponent(0)
                }
            }
        } else {
            if (ViewModel.shared.videoURL != "Second Half") {
                var fileUrl = URL(string: ViewModel.shared.firstHalfVideoUrl)!
                ViewModel.shared.videoURL = "Second Half"
                fileUrl = URL(string: ViewModel.shared.secondHalfVideoUrl)!
                self.videoPlayer.play(url: fileUrl)
                self.nextButton.setTitle("", for: .normal)
            }
        }
    }
    
    //MARK: Back Tapped Function
    @objc func backTapped() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { // animation for back button changes
            self.backButton.setTitle("<<<", for: .normal)
            self.backButton.setTitleColor(.systemRed, for: .normal)
            self.backButton.backgroundColor = .systemGray2.withAlphaComponent(0.5)
        }
        self.matchIdTextField.resignFirstResponder()
        let playerCurrentTime = CMTimeGetSeconds(videoPlayer.avPlayer.currentTime())
        var newTime = playerCurrentTime - seekDuration

        if newTime < 0 {
            newTime = 0
        }
        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        videoPlayer.avPlayer.seek(to: time2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { // that is used cause the screen show at least 1 second more.
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.backButton.setTitle("", for: .normal)
                self.backButton.backgroundColor = .white.withAlphaComponent(0)
            }
        }
    }
}
