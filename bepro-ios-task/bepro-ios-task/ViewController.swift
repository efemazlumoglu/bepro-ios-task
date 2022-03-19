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
    var videoUrl: String = ""
    var matchVideo: MatchVideo?
    let disposeBag = DisposeBag()
    
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
                    print("result: ", result)
                    self.matchVideo = result
                }, onError: {
                    error in
                    print("error inside view controller: ", error)
                }, onCompleted: {
                    print("completed event")
                }).disposed(by: disposeBag)
        } catch {
            print(error)
        }
        
        
//        let videoURL = URL(string: "\(self.videoUrl)")
//        let player = AVPlayer(url: videoURL!)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view.bounds
//        self.view.layer.addSublayer(playerLayer)
//        player.play()
    }


}

