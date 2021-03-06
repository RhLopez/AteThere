//
//  FoursquareAPIClient.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/4/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

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
    
    func search(withTerm term: String, withCoordinate coordinate: CLLocationCoordinate2D, completion: @escaping (Result<[SearchVenue], APIError>) -> Void) {
        let coordinateString = "\(coordinate.latitude),\(coordinate.longitude)"
        
        let endpoint = Foursquare.search(term: term, coordinate: coordinateString, key: apiKey)
        
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
                
                let venues = venuesDict.flatMap { SearchVenue(json: $0) }
                completion(.success(venues))
            }
        }
        task.resume()
    }
    
    func updateVenueDetails(_ venue: SearchVenue, completion: @escaping (Result<SearchVenue, APIError>) -> Void) {
        let endpoint = Foursquare.lookUp(id: venue.id, key: apiKey)

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
                
                venue.updateWithPhotos(json: venueDict)
                
                completion(.success(venue))
            }
        }
        task.resume()
    }
    
    func bestPhoto(_ venue: SearchVenue, completion: @escaping(Result<UIImage, APIError>) -> Void) {
        guard let urlString = venue.bestPhoto?.imageUrl else {
            completion(.failure(.invalidURL))
            return
        }
        
        getPhotoData(urlString) { (data, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(.invalidData))
                }
            }
        }
    }
    
    func getPhotos(forVenue venue: SearchVenue, completion: @escaping(Result<[SearchVenuePhoto], APIError>) -> Void) {
        let endpoint = Foursquare.photos(id: venue.id, key: apiKey)
        
        let task = jsonTask(with: endpoint.request) { (json, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(.failure(.invalidData))
                    return
                }
                
                guard let responseDict = json["response"] as? [String: AnyObject],
                    let photosDict = responseDict["photos"] as? [String: AnyObject],
                    let items = photosDict["items"] as? [[String: AnyObject]] else {
                        completion(.failure(.jsonConversionFailure))
                        return
                }
                
                let venuePhotos = items.flatMap { SearchVenuePhoto(json: $0) }
                completion(.success(venuePhotos))
            }
        }
        task.resume()
    }
    
    func getPhoto(forVenue venue: SearchVenue, atIndexPath indexPath: IndexPath, completion: @escaping (Result<IndexedImage, APIError>) -> Void) {
        guard let urlString = venue.photos[indexPath.row].imageUrl else {
            completion(.failure(.invalidURL))
            return
        }
        
        getPhotoData(urlString) { (data, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                if let image = UIImage(data: data) {
                    let indexedImage = IndexedImage(indexPath: indexPath, image: image)
                    venue.photos[indexPath.row].imageState = .downloaded(indexedImage)
                    completion(.success(indexedImage))
                } else {
                    completion(.failure(.invalidData))
                }
            }
        }
    }
}

enum Foursquare {
    case search(term: String, coordinate: String, key: APIKey)
    case lookUp(id: String, key: APIKey)
    case photos(id: String, key: APIKey)
}

extension Foursquare: Endpoint {
    var base: String {
        return Constants.base
    }
    
    var path: String {
        switch self {
        case .search: return Constants.version + Constants.venues + Constants.search
        case .lookUp(let id, _): return Constants.version + Constants.venues + "/\(id)"
        case .photos(let id, _): return Constants.version + Constants.venues + "/\(id)" + Constants.photos
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let term, let coordinate, let key):
            return [
                URLQueryItem(name: Constants.client, value: key.clientID),
                URLQueryItem(name: Constants.secret, value: key.clientSecret),
                URLQueryItem(name: Constants.location, value: coordinate),
                URLQueryItem(name: Constants.category, value: Constants.foodCategory),
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
        case .photos(_, let key):
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
        static let photos = "/photos"
        static let category = "categoryId"
        static let foodCategory = "4d4b7105d754a06374d81259"
    }
}

