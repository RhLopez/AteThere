//
//  APIClient.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/2/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

protocol APIClient {
    var session: URLSession { get }
}

extension APIClient {
    typealias JSON = [String:AnyObject]
    typealias JSONTaskCompletionHandler = (JSON?, APIError?) -> Void
    
    func jsonTask(with request: URLRequest, completionHandler: @escaping JSONTaskCompletionHandler) -> URLSessionTask {
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil,.requestError(message: error.localizedDescription))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else {
                completionHandler(nil, .requestFailed)
                return
            }
            
            guard let data = data else {
                completionHandler(nil, .invalidData)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                completionHandler(json, nil)
            } catch {
                completionHandler(nil, .jsonConversionFailure)
            }
        }
        
        return task
    }
}


