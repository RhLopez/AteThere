//
//  FoursquareAPIClient.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/4/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

class FoursquareAPIClient: APIClient {
    var apiKey: APIKey
    var session: URLSession
    
    init(sessionConfiguration: URLSessionConfiguration, apiKey: APIKey) {
        self.session = URLSession(configuration: sessionConfiguration)
        self.apiKey = apiKey
    }
    
    convenience init(apiKey: APIKey) {
        self.init(sessionConfiguration: .default, apiKey: apiKey)
    }
    
    func search(withTerm term: String, completion: @escaping (Result<[Venue], APIError>) -> Void) {
        let endpoint = Foursquare.search(term: term, key: apiKey)
        
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
    
    func lookUp(forId id: String, completion: @escaping (Result<Venue, APIError>) -> Void) {
        let endpoint = Foursquare.lookUp(id: id, key: apiKey)
        print(endpoint.request)
        let task = jsonTask(with: endpoint.request) { (json, error) in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(.failure(.invalidData))
                    return
                }
                
                guard let responseDict = json["response"] as? [String: AnyObject],
                    let venueDict = responseDict["venue"] as? [String: AnyObject] else {
                        completion(.failure(.jsonConversionFailure))
                        return
                }
                
                guard let venue = Venue(json: venueDict) else {
                    completion(.failure(.jsonConversionFailure))
                    return
                }
                
                completion(.success(venue))
            }
        }
        task.resume()
    }
}

enum Foursquare {
    case search(term: String, key: APIKey)
    case lookUp(id: String, key: APIKey)
}

extension Foursquare: Endpoint {
    var base: String {
        return Constants.base
    }
    
    var path: String {
        switch self {
        case .search: return Constants.version + Constants.venues + Constants.search
        case .lookUp(let id, _): return Constants.version + Constants.venues + "/\(id)"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let term, let key):
            return [
                URLQueryItem(name: Constants.client, value: key.clientID),
                URLQueryItem(name: Constants.secret, value: key.clientSecret),
                URLQueryItem(name: Constants.location, value: "33.881682,-118.117012"), // Remove hardcoded location
                URLQueryItem(name: Constants.query, value: term),
                URLQueryItem(name: Constants.versionParameter, value: Constants.versionDate),
                URLQueryItem(name: Constants.mode, value: Constants.modeType)
            ]
        case .lookUp(_, let key):
            return [
                URLQueryItem(name: Constants.client, value: key.clientID),
                URLQueryItem(name: Constants.secret, value: key.clientSecret),
                URLQueryItem(name: Constants.versionParameter, value: Constants.versionDate),
                URLQueryItem(name: Constants.mode, value: Constants.modeType)
            ]
        }
    }
}

extension Foursquare {
    struct Constants {
        static let base = "https://api.foursquare.com"
        static let version = "/v2"
        static let venues = "/venues"
        static let search = "/search"
        static let query = "query"
        static let client = "client_id"
        static let secret = "client_secret"
        static let intent = "intent"
        static let radius = "radius"
        static let location = "ll"
        static let versionParameter = "v"
        static let versionDate = "20170921"
        static let mode = "mode"
        static let modeType = "foursquare"
    }
}

