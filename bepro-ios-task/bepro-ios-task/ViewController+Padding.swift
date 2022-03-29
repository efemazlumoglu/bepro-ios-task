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
extension ViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
            case 0:
                return 46
            case 1:
                return 60
            default:
                return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
            case 0:
                return "\(row). Minute"
            case 1:
                return "\(row). Second"
            default:
                return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
            case 0:
                minutes = row
                minutes = minutes * 60000
            case 1:
                seconds = row
                seconds = seconds * 10000
            default:
                break;
        }
    }
    
    
    public func changePadding() {
        
        openTimePicker()
        
        self.videoPlayer.avPlayer.pause()
//        let alertController = UIAlertController(title: "Change The Padding Value", message: "", preferredStyle: .alert)
//        alertController.addTextField { (textField : UITextField!) -> Void in
//            textField.placeholder = "Enter Padding Value"
//            textField.text = ViewModel.shared.paddingValueFirstHalf
//            textField.keyboardType = .numberPad
//        }
//
//        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
//            let firstTextField = alertController.textFields![0] as UITextField
//            self.playButton.isUserInteractionEnabled = false
//            self.pauseButton.isUserInteractionEnabled = true
//            self.activityIndicator.isHidden = false
//            self.activityIndicator.startAnimating()
//
//            ViewModel.shared.paddingValueFirstHalf = firstTextField.text!
//
//            if ViewModel.shared.videoURL == "First Half" {
//                if Int(firstTextField.text!)! <= ViewModel.shared.firstHalfData!.endMatchTime {
//                    let value = Float64(Int(firstTextField.text!)!) / 1000
//                    let seekTime = CMTime(value: Int64(value), timescale: 1)
//                    self.videoPlayer.avPlayer.seek(to: seekTime, completionHandler: {
//                        completed in
//                    })
//                } else {
//                    self.present(alertController, animated: true)
//                }
//            } else {
//                if Int(firstTextField.text!)! <= ViewModel.shared.secondHalfData!.endMatchTime {
//                    let value = Float64(Int(firstTextField.text!)!) / 1000
//                    let seekTime = CMTime(value: Int64(value), timescale: 1)
//                    self.videoPlayer.avPlayer.seek(to: seekTime, completionHandler: {
//                        completed in
//                    })
//                } else {
//                    self.present(alertController, animated: true)
//                }
//            }
//
//        })
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
//
//        alertController.addAction(saveAction)
//        alertController.addAction(cancelAction)
//
//        self.present(alertController, animated: true, completion: nil)
//
    }
    
    func openTimePicker()  {
        
        playButton.isUserInteractionEnabled = false
        pauseButton.isUserInteractionEnabled = true
        activityIndicator.isHidden = false
        hideTableViewBool = true
        contentViewHideBool = true
        playerViewHideBool = true
        progressBarHideBool = true
        loadView()
        
        
        timePicker.frame = CGRect(x: 0.0, y: (self.view.center.y - 50), width: self.view.frame.width, height: 300.0)
        timePicker.backgroundColor = UIColor.systemGray6
        timePicker.layer.shadowOffset = CGSize(width: 10,
                                          height: 10)
        timePicker.layer.shadowRadius = 10
        timePicker.layer.shadowOpacity = 1
        timePicker.layer.shouldRasterize = true
        timePicker.layer.rasterizationScale = UIScreen.main.scale
        self.view.addSubview(timePicker)
        
        let button = UIButton(frame: CGRect(x: 0.0, y: self.timePicker.frame.maxY, width: self.timePicker.frame.width, height: 44))
        button.setTitle("Close", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(closePicker), for: .allTouchEvents)
        self.view.addSubview(button)
        
        let title = UILabel(frame: CGRect(x: 0.0, y: self.timePicker.frame.minY, width: self.timePicker.frame.width, height: 44))
        title.text = "Please Select The Start Minute of Match"
        self.view.addSubview(title)
    }
    
    @objc func closePicker() {
        
        let totalMilis = minutes + seconds
        
        if ViewModel.shared.videoURL == "First Half" {
            let value = Float64(Int(totalMilis)) / 1000
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            self.videoPlayer.avPlayer.seek(to: seekTime, completionHandler: {
                completed in
                self.videoPlayer.playPause(cmTime: seekTime)
            })
        } else {
            let value = Float64(Int(totalMilis)) / 1000
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            self.videoPlayer.avPlayer.seek(to: seekTime, completionHandler: {
                completed in
                self.videoPlayer.playPause(cmTime: seekTime)
            })
        }
        
        self.timePicker.removeFromSuperview()
        DispatchQueue.main.async {
            self.playButton.isUserInteractionEnabled = false
            self.pauseButton.isUserInteractionEnabled = true
            self.activityIndicator.isHidden = true
            self.hideTableViewBool = false
            self.contentViewHideBool = false
            self.playerViewHideBool = false
            self.progressBarHideBool = false
            self.loadView()
        }
    }
    
}
