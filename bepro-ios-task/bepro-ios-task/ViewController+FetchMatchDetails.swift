//
//  ViewController+FetchMatchDetails.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 29.03.2022.
//

import Foundation

extension ViewController {
    public func fetchVideoDetails() {
        
        let client = APIClient.shared
        do {
            try client.getMatchVideo(matchId: ViewModel.shared.matchId).subscribe(
                onNext: {
                    result in
                    
                    ViewModel.shared.matchVideo = result
                    ViewModel.shared.data = ViewModel.shared.matchVideo?.getData()
                    
                    ViewModel.shared.firstHalfData = ViewModel.shared.data![0]
                    ViewModel.shared.secondHalfData = ViewModel.shared.data![1]
                    
                    ViewModel.shared.paddingValueFirstHalf = String((ViewModel.shared.firstHalfData!.padding))
                    ViewModel.shared.paddingValueSecondHalf = String((ViewModel.shared.secondHalfData!.padding))
                    
                    ViewModel.shared.firstHalfVideo = ViewModel.shared.firstHalfData?.video
                    ViewModel.shared.secondHalfVideo = ViewModel.shared.secondHalfData?.video
                    
                    ViewModel.shared.firstHalfVideoTitle = (ViewModel.shared.firstHalfVideo!.title)
                    ViewModel.shared.secondHalfVideoTitle = (ViewModel.shared.secondHalfVideo!.title)
                    
                    ViewModel.shared.firstHalfVideoUrl = (ViewModel.shared.firstHalfVideo!.servingURL)
                    ViewModel.shared.secondHalfVideoUrl = (ViewModel.shared.secondHalfVideo!.servingURL)
                    
                }, onError: {
                    error in
                    print("error inside view controller: ", error)
                }, onCompleted: {
                    print("completed event")
                    DispatchQueue.main.async {
                        self.changeLayoutFunc()
                    }
                }).disposed(by: disposeBag)
        } catch {
            print(error)
        }
    }

}
