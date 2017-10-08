//
//  APIError.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/2/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case requestError(message: String)
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        case .requestError(let message): return "The request returned an error: \(message)"
        }
    }
}
