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
    enum Constants: String {
        case base
        case version
        case venues
        case search
        case query
        case client
        case secret
        case intent
        case radius
        case location
        case versionParameter
        case versionDate
        case mode
        case modeType
        
        var description: String {
            switch self {
            case .base: return "https://api.foursquare.com"
            case .version: return "/v2"
            case .venues: return "/venues"
            case .search: return "/search"
            case .query: return "query"
            case .client: return "client_id"
            case .secret: return "client_secret"
            case .intent: return "intent"
            case .radius: return "radius"
            case .location: return "ll"
            case .versionParameter: return "v"
            case .versionDate: return "20170921"
            case .mode: return "mode"
            case .modeType: return "foursquare"
            }
        }
    }
    
    case search(term: String)
    case lookUp(id: String)
}

extension Foursquare: Endpoint {
    var base: String {
        return Constants.base.description
    }
    
    var path: String {
        switch self {
        case .search: return Constants.version.description + Constants.venues.description + Constants.search.description
        case .lookUp(let id): return Constants.version.description + Constants.venues.description + "/\(id)"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let term):
            return [
                URLQueryItem(name: Constants.client.description, value: FoursquareAPIKey.clientID),
                URLQueryItem(name: Constants.secret.description, value: FoursquareAPIKey.clientSecret),
                URLQueryItem(name: Constants.location.description, value: "33.881682,-118.117012"), // Remove hardcoded location
                URLQueryItem(name: Constants.query.description, value: term),
                URLQueryItem(name: Constants.versionParameter.description, value: Constants.versionDate.description),
                URLQueryItem(name: Constants.mode.description, value: Constants.modeType.description)
            ]
        case .lookUp:
            return [
                URLQueryItem(name: Constants.client.description, value: FoursquareAPIKey.clientID),
                URLQueryItem(name: Constants.secret.description, value: FoursquareAPIKey.clientSecret),
                URLQueryItem(name: Constants.versionParameter.description, value: Constants.versionDate.description),
                URLQueryItem(name: Constants.mode.description, value: Constants.modeType.description)
            ]
        }
    }
}
