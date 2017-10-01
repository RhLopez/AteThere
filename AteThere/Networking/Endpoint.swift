//
//  Endpoint.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/1/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}

enum Foursquare {
    case search(term: String)
}

extension Foursquare: Endpoint {
    
    enum Constants: String {
        case base = "https://api.foursqure.com"
        case version = "/v2"
        case venues = "/venues"
        case search = "/search"
        case query = "query"
        case client = "client"
        case secret = "client_secret"
        case intent = "intent"
        case radius = "radius"
        case location = "ll"
        case versionParameter = "v"
        case versionDate = "20170921"
        case mode = "mode"
        case modeType = "foursqure"
    }
    
    var base: String {
        return Constants.base.rawValue
    }
    
    var path: String {
        switch self {
        case .search: return Constants.version.rawValue + Constants.venues.rawValue + Constants.search.rawValue
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let term):
            return [
                URLQueryItem(name: Constants.client.rawValue, value: FoursquareAPIKey.clientID),
                URLQueryItem(name: Constants.secret.rawValue, value: FoursquareAPIKey.clientSecret),
                URLQueryItem(name: Constants.query.rawValue, value: term),
                URLQueryItem(name: Constants.versionParameter.rawValue, value: Constants.versionDate.rawValue),
                URLQueryItem(name: Constants.mode.rawValue, value: Constants.modeType.rawValue)
            ]
        }
    }
}



