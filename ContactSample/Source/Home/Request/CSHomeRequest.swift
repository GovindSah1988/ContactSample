//
//  CSHomeRequest.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

enum CSHomeRequest: CSRequestable {
    case getContacts
    
    var baseURL: String? {
        switch self {
        case .getContacts:
            return CSNetworkConstants.APIEndpoints.allAlbums
        }
    }
    
    var parameters: APIParams? {
        switch self {
        case .getContacts:
            return fetchContactParams()
        }
    }
    
    var method: String? {
        return CSRequestMethod.get.rawValue
    }
    
}

extension CSHomeRequest {
    
    private func fetchContactParams() -> APIParams {
        return APIParams()
    }
}
