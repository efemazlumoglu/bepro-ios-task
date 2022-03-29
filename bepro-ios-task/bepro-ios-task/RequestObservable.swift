//
//  RequestObservable.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 19.03.2022.
//

import Foundation
import RxSwift
import RxCocoa

public class RequestObservable { // this observable this reactive way of doing it when you try to call the api
    private lazy var jsonDecoder = JSONDecoder()
    private var urlSession: URLSession
    public init (config: URLSessionConfiguration) {
        urlSession = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    //MARK: urlsession takes function
    public func callAPI<MatchVideo: Decodable>(request: URLRequest) -> Observable<MatchVideo> {
        return Observable.create { [weak self]
            observer in
            let task = self!.urlSession.dataTask(with: request) {
                (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) { // i add this contiditon for status codes otherwise i do not know which status is returning in which api calls
                            let objs = try self!.jsonDecoder.decode(MatchVideo.self, from: _data)
                            observer.onNext(objs)
                        } else {
                            print("observer on error: ", error!)
                            observer.onError(error!)
                        }
                    } catch {
                        print("error on calling api: ", error)
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
