//
//  ViewController+CallsHalfs.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 28.03.2022.
//

import Foundation
import UIKit

extension ViewController {
    
    // MARK: Call Halfs Method
    public func callHalfs(halfOption: String) { // for first half and second halfs of the game
        if (self.firstHalfVideoUrl == "" && self.secondHalfVideoUrl == "") {
            let alert = UIAlertController(title: "Warning", message: "Video url cannot found", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            var fileUrl = URL(string: self.firstHalfVideoUrl)!
            if halfOption == "First Half" {
                self.videoURL = "First Half"
                fileUrl = URL(string: self.firstHalfVideoUrl)!
                self.changePadding()
            } else {
                self.videoURL = "Second Half"
                fileUrl = URL(string: self.secondHalfVideoUrl)!
                self.changePadding()
            }
            self.videoPlayer.play(url: fileUrl)
            self.progressView.value = 0
            self.pauseButton.backgroundColor = UIColor.systemOrange.withAlphaComponent(1)
            self.playButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.4)
        }
    }
    
}
