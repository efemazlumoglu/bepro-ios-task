//
//  ViewController+Padding.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 28.03.2022.
//

import Foundation
import UIKit
import AVFoundation

extension ViewController {
    
    public func changePadding() {
        
        let alertController = UIAlertController(title: "Change The Padding Value", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Padding Value"
            textField.text = ViewModel.shared.paddingValueFirstHalf
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.playButton.isUserInteractionEnabled = false
            self.pauseButton.isUserInteractionEnabled = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            ViewModel.shared.paddingValueFirstHalf = firstTextField.text!
            
            if Int(firstTextField.text!)! <= ViewModel.shared.firstHalfData!.endMatchTime {
                if let duration = self.videoPlayer.avPlayer.currentItem?.duration {
                    
                    print(Float64(Int(firstTextField.text!)!))
                    
                    let value = Float64(Int(firstTextField.text!)!) * 1000
                    
                    print(value)
                    
                    
                    let seekTime = CMTime(value: Int64(value), timescale: 1)
                    
                    self.videoPlayer.avPlayer.seek(to: seekTime, completionHandler: {
                        completed in
                        //
                    })
                }
            }
            

        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
