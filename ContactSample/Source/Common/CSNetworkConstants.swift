//
//  CSNetworkConstants.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

enum AppEnvironment {
    case production
    case staging
    
    var baseUrl: String {
        switch self {
        case .production:
            return "http://gojek-contacts-app.herokuapp.com/"
        case .staging:
            return "http://gojek-contacts-app.herokuapp.com/"
        }
    }
    
}

struct CSNetworkConstants {
    
    static let environment:AppEnvironment = AppEnvironment.production
    
    struct APIEndpoints {
        static let baseurl = environment.baseUrl
        
        static let allContacts = baseurl + "contacts"
    }
    
}
