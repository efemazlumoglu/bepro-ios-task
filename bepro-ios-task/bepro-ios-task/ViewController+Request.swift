//
//  ViewController+Request.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 28.03.2022.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

extension ViewController {
    
    public func requestSending() {
        let client = APIClient.shared
        do {
            try client.getMatchVideo(matchId: self.matchId).subscribe(
                onNext: {
                    result in
                    
                    self.matchVideo = result
                    self.data = self.matchVideo?.getData()
                    
                    self.firstHalfData = self.data![0]
                    self.secondHalfData = self.data![1]
                    
                    self.paddingValueFirstHalf = self.firstHalfData!.padding
                    self.paddingValueSecondHalf = self.secondHalfData!.padding
                    
                    self.firstHalfVideo = self.firstHalfData?.video
                    self.secondHalfVideo = self.secondHalfData?.video
                    
                    self.firstHalfVideoTitle = self.firstHalfVideo!.title
                    self.secondHalfVideoTitle = self.secondHalfVideo!.title
                    
                    self.firstHalfVideoUrl = self.firstHalfVideo!.servingURL
                    self.secondHalfVideoUrl = self.secondHalfVideo!.servingURL
                    
                    DispatchQueue.main.async { // ui updates must be on main thread
                        self.videoURL = "First Half"
                        self.callHalfs(halfOption: "First Half")
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.hideTableViewBool = false
                        self.contentViewHideBool = false
                        self.playerViewHideBool = false
                        self.progressBarHideBool = false
                        self.loadView()
                        self.tableView.reloadData()
                    }
                    
                }, onError: {
                    error in
                    print("error inside view controller: ", error)
                }, onCompleted: {
                    print("completed event")
                }).disposed(by: disposeBag)
        } catch {
            print(error)
        }
    }
    
}
