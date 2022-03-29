//
//  ViewController+ChangeLayout.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 29.03.2022.
//

import Foundation

// MARK: Change the Layout after the fetch Details
extension ViewController {
    func changeLayoutFunc() {
        ViewModel.shared.videoURL = "First Half"
        self.callHalfs(halfOption: "First Half")
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        self.hideTableViewBool = false
        self.contentViewHideBool = false
        self.playerViewHideBool = false
        self.progressBarHideBool = false
        self.loadView()
        self.tableView.reloadData()
        self.changePadding()
    }
}
