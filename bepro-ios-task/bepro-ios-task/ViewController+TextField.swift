//
//  ViewController+TextField.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 28.03.2022.
//

import Foundation
import UIKit


//MARK: Extension for UITextField Delegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let matchId: Int = Int(textField.text!)!
        self.matchId = matchId
        if matchId != 25199 {
            self.matchId = 25199
            textField.text = "25199"
            let alert = UIAlertController(title: "Warning", message: "If the match Id is not 25199 you have to be logged in", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            playButton.isUserInteractionEnabled = false
            pauseButton.isUserInteractionEnabled = true
            activityIndicator.isHidden = false
            hideTableViewBool = true
            contentViewHideBool = true
            playerViewHideBool = true
            progressBarHideBool = true
            activityIndicator.startAnimating()
            self.loadView()
            self.requestSend()
        }
        textField.resignFirstResponder()
        return true
    }
}
