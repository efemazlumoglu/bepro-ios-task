//
//  ViewController+Padding.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 28.03.2022.
//

import Foundation
import UIKit
import AVFoundation

// MARK: Change the padding value to seek AVPlayer
extension ViewController {
    
    public func changePadding() {
        
        let alertController = UIAlertController(title: "Change The Padding Value", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Padding Value"
            textField.text = ViewModel.shared.paddingValueFirstHalf
            textField.keyboardType = .numberPad
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.playButton.isUserInteractionEnabled = false
            self.pauseButton.isUserInteractionEnabled = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            ViewModel.shared.paddingValueFirstHalf = firstTextField.text!
            
            if ViewModel.shared.videoURL == "First Half" {
                if Int(firstTextField.text!)! <= ViewModel.shared.firstHalfData!.endMatchTime {
                    let value = Float64(Int(firstTextField.text!)!) / 1000
                    let seekTime = CMTime(value: Int64(value), timescale: 1)
                    self.videoPlayer.avPlayer.seek(to: seekTime, completionHandler: {
                        completed in
                    })
                } else {
                    self.present(alertController, animated: true)
                }
            } else {
                if Int(firstTextField.text!)! <= ViewModel.shared.secondHalfData!.endMatchTime {
                    let value = Float64(Int(firstTextField.text!)!) / 1000
                    let seekTime = CMTime(value: Int64(value), timescale: 1)
                    self.videoPlayer.avPlayer.seek(to: seekTime, completionHandler: {
                        completed in
                    })
                } else {
                    self.present(alertController, animated: true)
                }
            }

        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
