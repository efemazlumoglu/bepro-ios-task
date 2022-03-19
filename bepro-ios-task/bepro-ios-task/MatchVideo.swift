//
//  MatchVideo.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 18.03.2022.
//

import Foundation

// MARK: - MatchVideo
struct MatchVideo: Codable {
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let id, matchID, videoID: Int
    let video: Video
    let isLive: Bool
    let created, modified: Date
    let padding, startMatchTime, endMatchTime: Int
    let eventPeriod: String
    let isActive, isPreserved: Bool
    let paddingSource: String
    let syncCompletedDatetime: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id
        case matchID = "matchId"
        case videoID = "videoId"
        case video, isLive, created, modified, padding, startMatchTime, endMatchTime, eventPeriod, isActive, isPreserved, paddingSource, syncCompletedDatetime
    }
}

// MARK: - Video
struct Video: Codable {
    let id: Int
    let userID: JSONNull?
    let parentVideoID, cameraRecordingID: Int
    let originalServingURL: String
    let originalFileURL: String
    let cameraRecording: CameraRecording
    let localServingURL: JSONNull?
    let created, modified: Date
    let title: String
    let storageKeys, extraStorageKeys: [JSONAny]
    let duration: Int
    let resizeEstimated: JSONNull?
    let resizeFinished: Date
    let originalFileKey, originalServingKey: String
    let checksum, parentChecksum: JSONNull?
    let cutStartTime: Int
    let cutEndTime, realStartTime: JSONNull?
    let isWatermarked: Bool
    let autoviewGraphicVideoFileKey: JSONNull?
    let scoutingviewVideoFileKey: String
    let scoutingviewServingKey: JSONNull?
    let graphicVideoFileKey, scoutingviewGraphicVideoFileKey: String
    let servingURL: String
    let localServingPath, rawFileKey, rawServingKey: JSONNull?
    let stitchingProgress: StitchingProgress
    let useLifecycleBucket, requestDelete: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case parentVideoID = "parentVideoId"
        case cameraRecordingID = "cameraRecordingId"
        case originalServingURL = "originalServingUrl"
        case originalFileURL = "originalFileUrl"
        case cameraRecording
        case localServingURL = "localServingUrl"
        case created, modified, title, storageKeys, extraStorageKeys, duration, resizeEstimated, resizeFinished, originalFileKey, originalServingKey, checksum, parentChecksum, cutStartTime, cutEndTime, realStartTime, isWatermarked, autoviewGraphicVideoFileKey, scoutingviewVideoFileKey, scoutingviewServingKey, graphicVideoFileKey, scoutingviewGraphicVideoFileKey
        case servingURL = "servingUrl"
        case localServingPath, rawFileKey, rawServingKey, stitchingProgress, useLifecycleBucket, requestDelete
    }
}

// MARK: - CameraRecording
struct CameraRecording: Codable {
    let id, cameraInfoID, matchID: Int
    let userID, parentRecordingID, recordingEndTime: JSONNull?
    let liveUrls: LiveUrls
    let syncVideoUrls: [String]
    let stitchingEstimated, created, modified, status: String
    let isProcessing: Bool
    let processingStartTime: Date
    let processingEndTime: String
    let liveStatus: JSONNull?
    let isLiveCoding: Bool
    let liveCodingStart: Int
    let liveStreamingURL: JSONNull?
    let eventPeriod: String
    let timings: Timings
    let stitchingSync: StitchingSync
    let syncCompleteTime: JSONNull?
    let stitchingStart: Int
    let recordingIDS: RecordingIDS
    let recordingResult: [String]
    let recordingStatus: String
    let intrinsicJSON: IntrinsicJSON
    let stitchingJSON, extrinsicJSON: JSON
    let parameter: Parameter
    let rawVideos: [EstimateVideoElement]
    let rawTrackingVideos: StitchingProgress
    let estimateVideos: [EstimateVideoElement]
    let estimateEndTime: Date
    let stitchedSnapshotKey: String
    let processProgress: ProcessProgress
    let stitchingCoverage, stitchingCycle: Int

    enum CodingKeys: String, CodingKey {
        case id
        case cameraInfoID = "cameraInfoId"
        case matchID = "matchId"
        case userID = "userId"
        case parentRecordingID = "parentRecordingId"
        case recordingEndTime, liveUrls, syncVideoUrls, stitchingEstimated, created, modified, status, isProcessing, processingStartTime, processingEndTime, liveStatus, isLiveCoding, liveCodingStart
        case liveStreamingURL = "liveStreamingUrl"
        case eventPeriod, timings, stitchingSync, syncCompleteTime, stitchingStart
        case recordingIDS = "recordingIds"
        case recordingResult, recordingStatus
        case intrinsicJSON = "intrinsicJson"
        case stitchingJSON = "stitchingJson"
        case extrinsicJSON = "extrinsicJson"
        case parameter, rawVideos, rawTrackingVideos, estimateVideos, estimateEndTime, stitchedSnapshotKey, processProgress, stitchingCoverage, stitchingCycle
    }
}

// MARK: - EstimateVideoElement
struct EstimateVideoElement: Codable {
    let xmlKey: String
    let duration: Double
    let videoKey: String
    let startTime: String?
}

// MARK: - JSON
struct JSON: Codable {
    let camera0, camera1, camera2: Camera

    enum CodingKeys: String, CodingKey {
        case camera0 = "Camera 0"
        case camera1 = "Camera 1"
        case camera2 = "Camera 2"
    }
}

// MARK: - Camera
struct Camera: Codable {
    let r, t: CameraMatrix
    let ppx, ppy, focal, aspect: Double

    enum CodingKeys: String, CodingKey {
        case r = "R"
        case t, ppx, ppy, focal, aspect
    }
}

// MARK: - CameraMatrix
struct CameraMatrix: Codable {
    let dt: Dt
    let cols: Int
    let data: [Double]
    let rows: Int
}

enum Dt: String, Codable {
    case d = "d"
    case f = "f"
}

// MARK: - IntrinsicJSON
struct IntrinsicJSON: Codable {
    let flags, boardWidth, imageWidth: Int
    let squareSize: Double
    let boardHeight, imageHeight: Int
    let cameraMatrix: CameraMatrix
    let calibrationTime: String
    let distortionCoefficients: CameraMatrix
}

// MARK: - LiveUrls
struct LiveUrls: Codable {
    let local, storage: JSONNull?
}

// MARK: - Parameter
struct Parameter: Codable {
    let brX, brY, tlX, tlY: Int
    let focus: [Double]
    let scale: Double
    let cropTop, cropLeft, cropRight, cropBottom: Int
    let imageWidth, videoWidth, groundWidth, imageHeight: Int
    let videoHeight, workMegapix, composeScale, groundHeight: Int
    let whiteBalance: [String]
    let composeMegapix: Int
}

// MARK: - ProcessProgress
struct ProcessProgress: Codable {
    let firstHalf, secondHalf: Half
    let latestDownloaded: String
    let latestDownloadedTimestamp: Double
    let status: String?
}

// MARK: - Half
struct Half: Codable {
    let percentage: Double
    let downloadedSize, totalVideoCount, downloadedVideoCount, alreadyDownloadedVideoCount: Int
}

// MARK: - StitchingProgress
struct StitchingProgress: Codable {
}

// MARK: - RecordingIDS
struct RecordingIDS: Codable {
    let nas: [String: String]
}

// MARK: - StitchingSync
struct StitchingSync: Codable {
    let xml: [String]
}

// MARK: - Timings
struct Timings: Codable {
    let automatic: Automatic
    let processed: Processed
}

// MARK: - Automatic
struct Automatic: Codable {
    let recordingEnd, firstHalfEnd, secondHalfEnd, firstHalfStart: Int
    let secondHalfStart: Int
}

// MARK: - Processed
struct Processed: Codable {
    let firstHalf: String
    let secondHalf: String?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
