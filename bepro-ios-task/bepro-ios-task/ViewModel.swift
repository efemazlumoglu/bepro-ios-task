//
//  self.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 28.03.2022.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class ViewModel {
    
    public var matchId: Int = 25199
    public var firstHalfVideoUrl: String = ""
    public var secondHalfVideoUrl: String = ""
    public var matchVideo: MatchVideo?
    public var data: [Datum]?
    public var disposeBag = DisposeBag()
    public var firstHalfData: Datum?
    public var secondHalfData: Datum?
    public var firstHalfVideo: Video?
    public var secondHalfVideo: Video?
    public var paddingValueFirstHalf: String = ""
    public var paddingValueSecondHalf: String = ""
    public var firstHalfVideoTitle: String = ""
    public var secondHalfVideoTitle: String = ""
    public var videoURL: String = ""
    
    static let shared = ViewModel()
    
    public let viewController = ViewController()
    
    private init(){}
    
    public func fetchVideoDetails() {
        
        let client = APIClient.shared
        do {
            try client.getMatchVideo(matchId: self.matchId).subscribe(
                onNext: {
                    result in
                    
                    self.matchVideo = result
                    self.data = self.matchVideo?.getData()
                    
                    self.firstHalfData = self.data![0]
                    self.secondHalfData = self.data![1]
                    
                    self.paddingValueFirstHalf = String((self.firstHalfData!.padding))
                    self.paddingValueSecondHalf = String((self.secondHalfData!.padding))
                    
                    self.firstHalfVideo = self.firstHalfData?.video
                    self.secondHalfVideo = self.secondHalfData?.video
                    
                    self.firstHalfVideoTitle = (self.firstHalfVideo!.title)
                    self.secondHalfVideoTitle = (self.secondHalfVideo!.title)
                    
                    self.firstHalfVideoUrl = (self.firstHalfVideo!.servingURL)
                    self.secondHalfVideoUrl = (self.secondHalfVideo!.servingURL)
                    
                    DispatchQueue.main.async { // ui updates must be on main thread
                        self.videoURL = "First Half"
                        self.viewController.callHalfs(halfOption: "First Half")
                        self.viewController.activityIndicator.isHidden = true
                        self.viewController.activityIndicator.stopAnimating()
                        self.viewController.hideTableViewBool = false
                        self.viewController.contentViewHideBool = false
                        self.viewController.playerViewHideBool = false
                        self.viewController.progressBarHideBool = false
                        self.viewController.loadView()
                        self.viewController.tableView.reloadData()
                        self.viewController.changePadding()
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
