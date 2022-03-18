//
//  APIEndpoints.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 18.03.2022.
//

import Foundation
import UIKit

enum APIEndpoint {
    case getMatch(Int)
    
    func url() -> String {
        switch self {
        case .getMatch(let matchId):
            return matchUrl("api/match-videos?matchId=\(matchId)")
        }
    }
}

extension APIEndpoint {
    fileprivate func apiBaseURL()->String{
        return "https://recruit-dev.bepro11.com/"
    }
    
    fileprivate func matchUrl(_ path:String)->String{
            
        let urlstring = "\(apiBaseURL())\(path)"
        
        guard let url = URL(string: urlstring) else{
            assert(false,"this should never be reached")
            return urlstring
        }
        
        let composedURL = APIService.compose(url: url)
        
        if let finalstring =  composedURL?.absoluteString {
            return finalstring
        }
        
        assert(false,"this should never be reached")
        return urlstring
    }
}

extension APIService {
    
    static func compose(url:URL)->URL?{
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        let queryItems =  Array(components.queryItems ?? [])
        
        components.queryItems = queryItems
        
        return try? components.asURL()
        
    }
}

