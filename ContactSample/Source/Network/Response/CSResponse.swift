//
//  CSResponse.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

// the generic type Result is stored as 'result' property type
struct CSResponse<Result> {
    // MARK: - Properties
    var request: CSRequestable?
    var headerReponse: [AnyHashable: Any]?
    var statusCode: Int?
    var result: Result?
    
    // MARK: - init method
    init(urlResponse: HTTPURLResponse?, result: Result? = nil, request: CSRequestable?) {
        self.request = request
        statusCode = urlResponse?.statusCode
        headerReponse = urlResponse?.allHeaderFields
        self.result = result
    }
}
