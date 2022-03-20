//
//  APIClient.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 19.03.2022.
//

import Foundation
import RxCocoa
import RxSwift

fileprivate extension Encodable { // this extension is for dictionary values casting if it is necesssary
  var dictionaryValue:[String: Any?]? {
      guard let data = try? JSONEncoder().encode(self),
      let dictionary = try? JSONSerialization.jsonObject(with: data,
        options: .allowFragments) as? [String: Any] else {
      return nil
    }
    return dictionary
  }
}

class APIClient { // this client is for getting match videos API Call 
    static var shared = APIClient()
    lazy var requestObservable = RequestObservable(config: .default)
    func getMatchVideo(matchId: Int) throws -> Observable<MatchVideo> {
        var request = URLRequest(url: URL(string: "https://recruit-dev.bepro11.com/api/match-videos?matchId=\(matchId)")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return requestObservable.callAPI(request: request)
    }
}
