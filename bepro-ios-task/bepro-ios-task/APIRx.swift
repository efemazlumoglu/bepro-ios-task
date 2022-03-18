//
//  APIRx.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 18.03.2022.
//

import UIKit
import RxSwift
import Alamofire
import AlamofireObjectMapper

extension Reactive where Base:APIService{
    
    func call<K:APIResponse>(_ endpoint : APIEndpoint) -> Single<K> {
        return Single<K>.create { single in
            
            let finish:APIClosure<K> = { response in
                guard let resource = response  else {
                    assert(false, "Unexpected response format")
                    single(.error(Services.error.type(.networkFailure)))
                }
                
                DispatchQueue.main.async {
                    single(.success(resource))
                }
            }
            
            switch endpoint{
            case .getMatch:
                APIService
                    .get(endpoint,completion: finish as! APIClosure<MatchVideo>)
            }
            
            return Disposables.create()
        }
    }
    
}
