//
//  CSBaseAgent.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

/// done in order to mock URLSessionDataTask
protocol CSURLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

/// done in order to mock URLSession
protocol CSURLSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping DataTaskResult) -> CSURLSessionDataTaskProtocol
}

extension URLSession: CSURLSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping DataTaskResult) -> CSURLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completion) as CSURLSessionDataTaskProtocol
    }
}

/// by default URLSessionDataTask has something called resume() method
/// so no need to add protocol's method - func resume()
extension URLSessionDataTask: CSURLSessionDataTaskProtocol { }

class CSBaseAgent {
    
    /// It is an object of CSURLSessionProtocol -
    /// which must adpot the functionalities of the URLSession ultimately.
    private (set) var session: CSURLSessionProtocol? // only for exposing the getter for session object
    
    // Adding dependency injection for URLSession so that it can be mocked
    init(session: CSURLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}
