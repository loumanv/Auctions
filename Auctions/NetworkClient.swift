//
//  NetworkClient.swift
//  Auctions
//
//  Created by Billybatigol on 03/09/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import UIKit
import Alamofire

struct Urls {
    static let baseUrl = "https://fc-ios-test.herokuapp.com"
    static let auctionsUrl = "/auctions"
}

enum ResponseError: LocalizedError {
    case connection
    case jsonResponseEmpty
}

class NetworkClient {
    
    public static let shared = NetworkClient()
    
    func load(url: URL, completion: @escaping ((Any?, Error?) -> Void)) {
        Alamofire.request(url).responseJSON { response in
            
            switch response.result {
            case .success(let data):
                completion(data, nil)
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

