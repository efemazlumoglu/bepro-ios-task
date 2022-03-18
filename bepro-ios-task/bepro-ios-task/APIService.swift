//
//  APIService.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 18.03.2022.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

typealias APIClosure<K> = (K?)->Void

class APIService: NSObject {
    
    static let QUEUE = DispatchQueue(label: "com.efemaz.bepro-ios-task", qos: .background, attributes: .concurrent)
    
    
    static func get<K:Mappable>(_ endpoint:APIEndpoint, completion: @escaping APIClosure<K>) -> Void {
        APIService.get(endpoint.url(), completion: completion)
    }
    
    static func get<K:Mappable>(_ endpointURL:String, completion: @escaping APIClosure<K>) -> Void {
        
        Alamofire.request(endpointURL).responseObject(queue: APIService.QUEUE) { (response: DataResponse<K>) in
            
            guard let response = response.result.value else {
                assert(false, "Unexpected response format")
                completion(nil)
            }
            
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
}
