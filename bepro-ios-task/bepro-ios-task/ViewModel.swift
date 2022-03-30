//
//  self.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 28.03.2022.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

// MARK: ViewModel for response from API
public struct ViewModel {
    
    public var matchId: Int = 25199
    public var firstHalfVideoUrl: String = ""
    public var secondHalfVideoUrl: String = ""
    public var matchVideo: MatchVideo?
    public var data: [Datum]?
    public var disposeBag = DisposeBag()
    public var firstHalfData: Datum?
    public var secondHalfData: Datum?
    public var firstHalfVideo: Video?
    public var secondHalfVideo: Video?
    public var paddingValueFirstHalf: String = ""
    public var paddingValueSecondHalf: String = ""
    public var firstHalfVideoTitle: String = ""
    public var secondHalfVideoTitle: String = ""
    public var videoURL: String = ""
    
    static var shared = ViewModel()
    
}
