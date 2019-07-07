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
            return "https://gist.githubusercontent.com/mohammadZ74/"
        case .staging:
            return "https://gist.githubusercontent.com/mohammadZ74/"
        }
    }
    
}

struct CSNetworkConstants {
    
    static let environment:AppEnvironment = AppEnvironment.production
    
    struct APIEndpoints {
        static let baseurl = environment.baseUrl
        
        static let allAlbums = baseurl + "dcd86ebedb5e519fd7b09b79dd4e4558/raw/b7505a54339f965413f5d9feb05b67fb7d0e464e/MvvmExampleApi.json"
    }
    
}
