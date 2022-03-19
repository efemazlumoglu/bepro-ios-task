//
//  ViewController.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 18.03.2022.
//

import UIKit
import Foundation
import AVFoundation
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var matchId: Int = 25199
    var firstHalfVideoUrl: String = ""
    var secondHalfVideoUrl: String = ""
    var matchVideo: MatchVideo?
    var data: [Datum]?
    let disposeBag = DisposeBag()
    var firstHalfData: Datum?
    var secondHalfData: Datum?
    var firstHalfVideo: Video?
    var secondHalfVideo: Video?
    var videoURL: URL?
    private let videoPlayer = StreamingVideoPlayer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // match id fetch
        // video url fetch
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = APIClient.shared
        do {
            try client.getMatchVideo(matchId: self.matchId).subscribe(
                onNext: {
                    result in
                    
                    self.matchVideo = result
                    self.data = self.matchVideo?.getData()
                    
                    self.firstHalfData = self.data![0]
                    self.secondHalfData = self.data![1]
                    
                    self.firstHalfVideo = self.firstHalfData?.video
                    self.secondHalfVideo = self.secondHalfData?.video
                    
                    self.firstHalfVideoUrl = self.firstHalfVideo!.servingURL
                    self.secondHalfVideoUrl = self.secondHalfVideo!.servingURL
                    
                    print(self.firstHalfVideoUrl)
                    print(self.secondHalfVideoUrl)
                    
                    self.videoURL = URL(string: "\(self.firstHalfVideoUrl)")
                    
                }, onError: {
                    error in
                    print("error inside view controller: ", error)
                }, onCompleted: {
                    print("completed event")
                }).disposed(by: disposeBag)
        } catch {
            print(error)
        }
        
        setupVideoPlayer()
        
    }
    
    private func setupVideoPlayer() {
        videoPlayer.add(to: self.view)
    }
}

