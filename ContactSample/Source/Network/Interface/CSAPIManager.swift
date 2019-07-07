//
//  CSAPIManager.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

class CSAPIManager {
    
    let agent: CSAgentProtocol?
    
    init(agent: CSAgentProtocol? = RSAgentFactory.agent(cachePolicy: .network)) {
        self.agent = agent
    }
    
    /**
     type:  will tell which response Type the generic A is
     Also response type must be a subclass of CSResponseBaseModel
     */
    func executeRequest<A>(request: CSRequestable, responseType: A.Type, completion: @escaping (CSResponse<A>?, Error?) -> Void) where A: CSResponseBaseModel {
        agent?.execute(request: request) { (responseObject, error) in
            completion(responseObject, error)
        }
    }
    
    /// to cancel the ongoing network request
    func cancelRequest() {
        agent?.cancelRequest()
    }
}

class RSAgentFactory {
    static func agent(cachePolicy: CSCachePolicy) -> CSAgentProtocol? {
        switch cachePolicy {
        case .local:
            return CSLocalAgent() //Can be used to create CSLocalAgent() in case we have anything to store on db
        case .network:
            return CSNetworkAgent()
        }
    }
}
