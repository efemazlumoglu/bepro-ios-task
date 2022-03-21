//
//  CMTimeExt.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 21.03.2022.
//

import Foundation

extension CMTime {
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

    public var seconds: Double? {
        let time = CMTimeGetSeconds(self)
        guard time.isNaN == false else { return nil }
        return time
    }
}
