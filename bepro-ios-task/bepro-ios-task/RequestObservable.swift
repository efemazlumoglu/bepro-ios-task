//
//  RequestObservable.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 19.03.2022.
//

import Foundation
import RxSwift
import RxCocoa

public class RequestObservable {
    private lazy var jsonDecoder = JSONDecoder()
    private var urlSession: URLSession
    public init (config: URLSessionConfiguration) {
        urlSession = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    //MARK: urlsession takes function
    public func callAPI<MatchVideo: Decodable>(request: URLRequest) -> Observable<MatchVideo> {
        return Observable.create {
            observer in
            let task = self.urlSession.dataTask(with: request) {
                (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            let objs = try self.jsonDecoder.decode(MatchVideo.self, from: _data)
                            observer.onNext(objs)
                        } else {
                            observer.onError(error!)
                        }
                    } catch {
                        observer.onError(error)
                    }
                }
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
