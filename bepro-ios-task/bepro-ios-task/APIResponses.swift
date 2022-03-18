//
//  APIResponses.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 18.03.2022.
//

import UIKit
import ObjectMapper

protocol APIResponse {
    func  items<K>(_ type:K.Type? )->[K]
}

extension APIResponse{
    func  items<K>(_ type:K.Type? = nil)->[K]{
        return ([self] as? [K]) ?? []
    }
}

extension MatchVideo: APIResponse{}

struct APIResponseMovieList: Mappable,APIResponse {
    
    var results: [MatchVideo]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        results <- map["results"]
    }
    
    func  items<K>(_ type:K.Type? = nil)->[K]{
        return (results as? [K]) ?? []
    }
    
}
