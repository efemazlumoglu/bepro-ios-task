//
//  MatchVideo.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 18.03.2022.
//

import UIKit

// MARK: - MatchVideo

public struct MatchVideo: Codable {
    var data: [Datum]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(data: [Datum]) {
        self.data = data
    }
    
    func getData() -> [Datum] {
        return self.data
    }
}

public struct Datum: Codable {
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
    
    init(id: Int, matchID: Int, videoID: Int, video: Video, padding: Int, startMatchTime: Int, endMatchTime: Int, eventPeriod: String) {
        self.id = id
        self.matchID = matchID
        self.videoID = videoID
        self.video = video
        self.padding = padding
        self.startMatchTime = startMatchTime
        self.endMatchTime = endMatchTime
        self.eventPeriod = eventPeriod
    }
    func getId() -> Int {
        return self.id
    }
    func getMatchId() -> Int {
        return self.matchID
    }
    func getVideoId() -> Int {
        return self.videoID
    }
    func getVideo() -> Video {
        return self.video
    }
    func getPadding() -> Int {
        return self.padding
    }
    func getStartMatchTime() -> Int {
        return self.startMatchTime
    }
    func getEndMatchTime() -> Int {
        return self.endMatchTime
    }
    func getEventPeriod() -> String {
        return self.eventPeriod
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
    
    init(id: Int, title: String, servingURL: String, duration: Int) {
        self.id = id
        self.title = title
        self.servingURL = servingURL
        self.duration = duration
    }
    func getId() -> Int {
        return self.id
    }
    func getTitle() -> String {
        return self.title
    }
    func getServingUrl() -> String {
        return self.servingURL
    }
    func getDuration() -> Int {
        return self.duration
    }
}
