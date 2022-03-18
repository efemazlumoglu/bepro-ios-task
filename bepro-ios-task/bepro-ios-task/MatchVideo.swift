//
//  MatchVideo.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 18.03.2022.
//

import UIKit
import ObjectMapper
import RxDataSources

// MARK: - MatchVideo
public struct MatchVideo: Codable, Mappable {
    var id, matchID, videoID: Int
    var video: Video
    var padding, startMatchTime, endMatchTime: Int
    var eventPeriod: String

    enum CodingKeys: String, CodingKey {
        case id
        case matchID = "matchId"
        case videoID = "videoId"
        case video, padding, startMatchTime, endMatchTime, eventPeriod
    }
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        id   <- map["id"]
        matchID   <- map["matchId"]
    }
}

// MARK: - Video
public struct Video: Codable {
    let id: Int
    let title: String
    let servingURL: String
    let duration: Int

    enum CodingKeys: String, CodingKey {
        case id, title
        case servingURL = "servingUrl"
        case duration
    }
}
