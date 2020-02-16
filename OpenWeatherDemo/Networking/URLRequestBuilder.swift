//
//  URLRequestBuilder.swift
//  MenuApp
//
//  Created by mohamed hussein on 2/13/20.
//  Copyright © 2020 mohamed hussein. All rights reserved.
//

import Foundation
import Alamofire

protocol URLRequestBuilder: URLRequestConvertible {
    
    var mainURL: URL { get }
    
    var requestURL: URL { get }
    
    var path: String { get }
    
    var header: HTTPHeaders { get }
    
    var parameters: Parameters? { get }
    
    var method: HTTPMethod { get }
    
    var encoding: ParameterEncoding { get }
    
    var urlRequest: URLRequest { get }
    
}


extension URLRequestBuilder {
    
    var mainURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/")!
    }
    
    var requestURL: URL {
        return mainURL.appendingPathComponent(path)
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        header.forEach{ request.addValue($0.value, forHTTPHeaderField: $0.name)}
        return request
    }
    
    func asURLRequest() throws -> URLRequest {
        return try encoding.encode(urlRequest, with: parameters)
    }
}
