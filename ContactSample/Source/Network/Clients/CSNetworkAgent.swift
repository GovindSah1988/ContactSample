//
//  CSNetworkAgent.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

class CSNetworkAgent: CSBaseAgent {
    
    /// It is an object of CSURLSessionDataTaskProtocol -
    /// which must adpot the functionalities of the URLSessionDataTask ultimately.
    var requestTask: CSURLSessionDataTaskProtocol?
}

typealias CSDataResponse<A> = (CSResponse<A>?, Error?) -> Void

extension CSNetworkAgent: CSAgentProtocol {
    
    internal func execute<A>(request: CSRequestable, completion: @escaping CSDataResponse<A>) where A: CSResponseBaseModel {
        
        do {
            let urlRequest = try request.asURLRequest()
            // making request on global queue
            DispatchQueue.global(qos: .userInitiated).async {
                self.requestTask = self.session?.dataTask(with: urlRequest as URLRequest, completion: { data, res, error -> Void in
                    if nil !=  error {
                        var err = CSError.unknown
                        if (error as NSError?)?.code == NSURLErrorCancelled {
                            err = CSError.requestCancelled
                        } else if (error as NSError?)?.code == NSURLErrorNotConnectedToInternet {
                            err = CSError.notConnectedToInternet
                        }
                        DispatchQueue.main.async {
                            completion(nil, err)
                        }
                    } else {
                        guard let data = data else {
                            let response = CSResponse<A>(urlResponse: res as? HTTPURLResponse, request: request)
                            DispatchQueue.main.async {
                                completion(response, CSError.unknown)
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            let response = CSResponse(urlResponse: res as? HTTPURLResponse, result: A.init(data: data), request: request)
                            completion(response, nil)
                        }
                    }
                })
                self.requestTask?.resume()
            }
        } catch {
            completion(nil, error as! CSError)
        }
        
    }
    
    func cancelRequest() {
        self.requestTask?.cancel()
    }
}
