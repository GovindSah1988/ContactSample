//
//  CSLocalAgent.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

class CSLocalAgent: CSBaseAgent {
    
}

extension CSLocalAgent: CSAgentProtocol {
    
    internal func execute<A>(request: CSRequestable, completion: @escaping CSDataResponse<A>) where A: CSResponseBaseModel {
        
        DispatchQueue.main.async {
            let response = CSResponse(urlResponse: nil, result: A.init(data: nil), request: request)
            completion(response, nil)
        }
    }
    
    func cancelRequest() {
        // do nothing
    }
}
