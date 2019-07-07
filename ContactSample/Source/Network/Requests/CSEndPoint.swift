//
//  CSEndPoint.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

typealias HeaderParams = [String: String]
typealias APIParams = [String: Any]

/* CSEndpoint protocol defines a set a rules, on conforming to which, a type can
 be classfied as a API request */
protocol CSEndpoint {
    var baseURL: String? { get } // base url of the request
    var path: String? { get } // path component of the url
    var method: String? { get } // HTTP Method (e.g. GET, POST etc)
    var headers: HeaderParams? { get } // Header parameters
    var parameters: APIParams? { get } // Request Body/ Query Params
}

extension CSEndpoint {
    internal var baseURL: String? { return "" }
    internal var path: String? { return nil }
    internal var method: String? { return CSRequestMethod.get.rawValue }
    internal var headers: HeaderParams? { return [:] }
    internal var parameters: APIParams? { return nil }
}
