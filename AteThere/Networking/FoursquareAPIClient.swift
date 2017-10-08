//
//  FoursquareAPIClient.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/4/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

class FoursquareAPIClient: APIClient {
    var session: URLSession
    
    init(sessionConfiguration: URLSessionConfiguration) {
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    convenience init() {
        self.init(sessionConfiguration: .default)
    }
    
    func search(withTerm term: String, completion: @escaping (Result<[Venue], APIError>) -> Void) {
        let endpoint = Foursquare.search(term: term)
        
        let task = jsonTask(with: endpoint.request) { (json, error) in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(.failure(.invalidData))
                    return
                }
                
                guard let responseDict = json["response"] as? [String: AnyObject],
                    let venuesDict = responseDict["venues"] as? [[String: AnyObject]] else {
                        completion(.failure(.jsonParsingFailure))
                        return
                }
                
                let venues = venuesDict.flatMap { Venue(json: $0) }
                completion(.success(venues))
            }
        }
        task.resume()
    }
}
