//
//  CMTimeExt.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 21.03.2022.
//

import Foundation
import AVFoundation

extension CMTime { // this extension is for view controller variable called total time and current time cause videoPlayer.playerController...duration and currentTime is returning CMTime values i need to convert them into the string for showing them.
    public var displayTime: String? {
        guard let sec = seconds?.rounded() else { return nil }

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        if sec < 60 * 60 {
            formatter.allowedUnits = [.minute, .second]
        } else {
            formatter.allowedUnits = [.hour, .minute, .second]
        }
        return formatter.string(from: sec) ?? nil
    }

    public var seconds: Double? { // return the seconds of time
        let time = CMTimeGetSeconds(self)
        guard time.isNaN == false else { return nil }
        return time
    }
}
