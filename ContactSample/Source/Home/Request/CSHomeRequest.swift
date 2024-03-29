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
    case getContactDetail(contact: CSContact)
    case saveContact(contact: CSContact)
    case addContact(contact: CSContact)
    case deleteContact(contact: CSContact)
    
    var baseURL: String? {
        switch self {
        case .getContacts:
            return CSNetworkConstants.APIEndpoints.allContacts
        case .getContactDetail(let contact):
            return contact.detailUrl ?? CSNetworkConstants.APIEndpoints.allContacts + "/" + String(contact.id!) + ".json"
        case .saveContact(let contact):
            return contact.detailUrl ?? CSNetworkConstants.APIEndpoints.allContacts + "/" + String(contact.id!) + ".json"
        case .addContact(_):
            return CSNetworkConstants.APIEndpoints.allContacts
        case .deleteContact(let contact):
            return contact.detailUrl ?? CSNetworkConstants.APIEndpoints.allContacts + "/" + String(contact.id!) + ".json"
        }
    }
    
    var parameters: APIParams? {
        switch self {
        case .getContacts:
            return nil
        case .getContactDetail(_):
            return nil
        case .saveContact(_):
            return nil
        case .addContact(_):
            return nil
        case .deleteContact(_):
            return nil
        }
    }
    
    var method: String? {
        switch self {
        case .getContacts, .getContactDetail(_):
            return CSRequestMethod.get.rawValue
        case .saveContact(_):
            return CSRequestMethod.put.rawValue
        case .addContact(_):
            return CSRequestMethod.post.rawValue
        case .deleteContact(_):
            return CSRequestMethod.delete.rawValue
        }
    }
    
    /// Setting "application/json" value for both content type and accept headers
    var headers: HeaderParams? {
        var parameters = HeaderParams()
        parameters[CSConstants.HeaderConstants.contentType] = CSConstants.HeaderConstants.contentTypeJson
        parameters[CSConstants.HeaderConstants.accept] = CSConstants.HeaderConstants.acceptJson
        return parameters
    }
    
    var httpBody: Data? {
        switch self {
        case .saveContact(let contact):
            do {
                return try JSONEncoder().encode(contact)
            } catch {
                
            }
        case .addContact(let contact):
            do {
                return try JSONEncoder().encode(contact)
            } catch {
                
            }
        default:
            return nil
        }
        return nil
    }
}
