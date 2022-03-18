//
//  MatchVideo.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 18.03.2022.
//

import Foundation

// MARK: - MatchVideo
public struct MatchVideo: Codable {
    let id, matchID, videoID: Int
    let video: Video
    let padding, startMatchTime, endMatchTime: Int
    let eventPeriod: String

    enum CodingKeys: String, CodingKey {
        case id
        case matchID = "matchId"
        case videoID = "videoId"
        case video, padding, startMatchTime, endMatchTime, eventPeriod
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
