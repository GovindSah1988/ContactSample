//
//  CSRequestable.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

protocol CSRequestable: CSEndpoint {
    
}

extension CSRequestable {
    func asURLRequest() throws -> URLRequest {
        guard let urlString = baseURL else {
            throw CSError.pathMissing
        }
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw CSError.pathMissing
        }
        
        var urlComponents = URLComponents(string: encodedUrlString)!
        var queryItems = [URLQueryItem]()
        if let parameters = parameters {
            for param in parameters {
                queryItems.append(URLQueryItem(name: param.key, value: param.value as? String))
            }
            urlComponents.queryItems = queryItems
        }
        guard let resourceURL = urlComponents.url else { throw CSError.urlMalformed }
        let request = NSMutableURLRequest(url: resourceURL)
        request.httpMethod = method!
        request.httpBody = httpBody
        request.allHTTPHeaderFields = headers
        return request as URLRequest
    }
}
