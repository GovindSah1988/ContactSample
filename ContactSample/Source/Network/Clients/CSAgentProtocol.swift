//
//  CSAgentProtocol.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

protocol CSAgentProtocol {
    // A - generic type which allows any response type(provided it conforms to CSResponseBaseModel)
    func execute<A>(request: CSRequestable, completion: @escaping (CSResponse<A>?, Error?) -> Void) where A: CSResponseBaseModel
    func cancelRequest()
}
