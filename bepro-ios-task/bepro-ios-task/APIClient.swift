//
//  APIClient.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 19.03.2022.
//

import Foundation
import RxCocoa
import RxSwift



class APIClient {
    static var shared = APIClient()
    lazy var requestObservable = RequestObservable(config: .default)
    func getMatchVideo(matchId: Int) throws -> Observable<MatchVideo> {
        var request = URLRequest(url: URL(string: "https://recruit-dev.bepro11.com/api/match-videos?matchId=\(matchId)")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return requestObservable.callAPI(request: request)
    }
}
