//
//  ViewController+Padding.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 28.03.2022.
//

import Foundation
import UIKit

extension ViewController {
    
    public func changePadding() {
        
        let alertController = UIAlertController(title: "Change The Padding Value", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Padding Value"
            textField.text = self.paddingValueFirstHalf
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.playButton.isUserInteractionEnabled = false
            self.pauseButton.isUserInteractionEnabled = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            self.paddingValueFirstHalf = firstTextField.text!
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter First Name"
        }

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
