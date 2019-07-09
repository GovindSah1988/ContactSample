//
//  CSNetworkAgentTests.swift
//  ContactSampleTests
//
//  Created by Govind Sah on 09/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import XCTest
@testable import ContactSample

/// The MockURLSession acts like a URLSession
class CSMockURLSession: CSURLSessionProtocol {
    
    // for exposing lastURL only as a getter,
    // can be still accessed as public
    private (set) var lastURL: URL?
    
    var currentDataTask = CSMockURLSessionDataTask()
    var responseData: Data?
    var error: Error?
    
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    func failedHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completion: @escaping DataTaskResult) -> CSURLSessionDataTaskProtocol {
        lastURL = request.url
        completion(responseData, (nil == error) ? successHttpURLResponse(request: request) : failedHttpURLResponse(request: request), error)
        return currentDataTask
    }
}

/**In URLSession, the return value must be a URLSessionDataTask.
 However, the URLSessionDataTask can’t be created programmatically,
 thus, this is an object that needs to be mocked
 */
class CSMockURLSessionDataTask: CSURLSessionDataTaskProtocol {
    
    private (set) var isResumed = false
    private (set) var isCancelled = false
    
    func cancel() {
        isCancelled = true
    }
    
    func resume() {
        isResumed = true
    }
}

class CSNetworkAgentTests: XCTestCase {
    
    let session = CSMockURLSession()
    var apiManager: CSAPIManager!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        apiManager = CSAPIManager(agent: CSNetworkAgent(session: session))
    }
    
    func test_request_fail() {
        
        session.error = CSError.unknown
        
        let request = CSHomeRequest.getContacts
        
        apiManager.executeRequest(request: request, responseType: CSContactResponse.self) { (response, error) in
            XCTAssertEqual(CSError.unknown, error as! CSError)
        }
    }
    
    func test_request_fail_network_error() {
        
        session.error = NSError(domain: "testDomain", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        
        let request = CSHomeRequest.getContacts
        
        apiManager.executeRequest(request: request, responseType: CSContactResponse.self) { (response, error) in
            XCTAssertEqual(CSError.notConnectedToInternet, error as! CSError)
        }
    }

    func test_request_cancel() {
        
        session.error = NSError(domain: "", code: NSURLErrorCancelled, userInfo: nil)
        
        let request = CSHomeRequest.getContacts
        apiManager.executeRequest(request: request, responseType: CSContactResponse.self) { (response, error) in
            
            // Return data
            // Asserting if the error is present
            XCTAssert(CSError.requestCancelled.localizedDescription == error?.localizedDescription)
            
        }
    }
    
    func test_request_data() {
        
        session.responseData = Data()
        
        let request = CSHomeRequest.getContacts
        
        let completion = expectation(description: "completion")
        
        apiManager.executeRequest(request: request, responseType: CSContactResponse.self) { (response, error) in
            
            completion.fulfill()
            
            // Return data
            // Asserting if the error is present
            XCTAssert(nil == error)
        }
        
        // to wait out for 1 sec and then call the completion
        wait(for: [completion], timeout: 1)
    }
    
    /// for testing whether the network agent sends the same url for making the request as intended
    func test_getContacts_request_url() {
        let request = CSHomeRequest.getContacts
        
        let completion = expectation(description: "data task resumed")
        
        apiManager.executeRequest(request: request, responseType: CSContactResponse.self) { (response, error) in
            
            // Return data
            
            completion.fulfill()
            
            do {
                let requestUrl = try request.asURLRequest().url
                let actualUrl = try response?.request?.asURLRequest().url
                
                // Asserting if the intended request url is different than the actual network request url
                XCTAssert(requestUrl == actualUrl)
                
            } catch {
                
            }
            
        }
        
        wait(for: [completion], timeout: 2)
        
        // Asserting if the intended request url is different than the actual network request url
        do {
            let url = try request.asURLRequest().url
            XCTAssert(session.lastURL == url)
        } catch {
            
        }
    }
    
    /// for testing the cancel functionality for any outstanding search request
    func test_cancel_outstanding_getContacts_request() {
        
        let dataTask = CSMockURLSessionDataTask()
        session.currentDataTask = dataTask
        
        let request = CSHomeRequest.getContacts
        
        let completion = expectation(description: "data task resumed")
        
        apiManager.executeRequest(request: request, responseType: CSContactResponse.self) { (response, error) in
            // data
            completion.fulfill()
        }
        
        wait(for: [completion], timeout: 3)
        
        XCTAssert(false == dataTask.isCancelled)
        
        let cancelCompletion = expectation(description: "data task cancelled")
        
        apiManager.cancelRequest()
        
        cancelCompletion.fulfill()
        
        wait(for: [cancelCompletion], timeout: 3)
        
        XCTAssert(true == dataTask.isCancelled)
    }
    
    /// to test whether the request is actually submitted or not
    func test_get_resume_called() {
        let dataTask = CSMockURLSessionDataTask()
        session.currentDataTask = dataTask
        
        let request = CSHomeRequest.getContacts
        
        let completion = expectation(description: "data task resumed")
        
        apiManager.executeRequest(request: request, responseType: CSContactResponse.self) { (response, error) in
            
            completion.fulfill()
        }
        
        waitForExpectations(timeout: 3) { (_) in
            XCTAssert(true == dataTask.isResumed)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
