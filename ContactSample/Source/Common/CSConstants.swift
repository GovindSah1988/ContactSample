//
//  CSConstants.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

struct CSConstants {
    
    struct CSWidthConstraint {
        static var titleMaxWidth = 51.5
    }
    
    /// add all the localized constant here
    struct CSLocalizedStringConstants {
        static let alertOk = "OK"
        static let commonErrorInfo = "Something Went Wrong. Unable to connect to Server!!"
        static let homeTitle = "Contact"
        static let emptyContent = "No Contents To Show!!"
        static let editAddSuccessMessage = "Contact is successfully updated."
    }
    
    /// add all the view identifiers here
    struct CSViewIdentifiers {
        static let contactDetailVC = "CSContactDetailViewController"
        static let addEditContactVC = "CSAddEditContactViewController"
        static let contactTVC = "CSContactTableViewCell"
    }
    
    /// add all the storyboard name here
    struct CSStoryboardConstants {
        static let main = "Main"
    }
    
    struct HeaderConstants {
        static let contentType = "Content-Type"
        static let accept = "Accept"
        static let contentTypeJson = "application/json"
        static let acceptJson = "application/json"
    }

}

enum CSContactDetailRow: Int {
    case firstName = 0
    case lastName
    case mobile
    case email
    
    var description: String {
        switch self {
        case .firstName:
            return "First Name"
        case .lastName:
            return "Last Name"
        case .mobile:
            return "mobile"
        case .email:
            return "email"
        }
    }
}

enum CSError: Error {
    case unknown
    case pathMissing
    case urlMalformed
    case requestCancelled
    case notConnectedToInternet
    case contactFetchingError
}

/** Specifies the cache policies used in the app
 - network : The data is directly fetched from the network and cache is updated
 - local   : The data is fetched from the cache (in our case 'Realm')
 */
enum CSCachePolicy: Int {
    case network
    case local
}

enum CSRequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}
