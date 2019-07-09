//
//  CSHomePresenterTests.swift
//  ContactSampleTests
//
//  Created by Govind Sah on 09/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import XCTest
@testable import ContactSample

class CSHomePresenterTests: XCTestCase {

    let session = CSMockURLSession()
    var apiManager: CSAPIManager!
    var homePresenter: CSHomePresenter!
    var expectation: XCTestExpectation!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        if let path = Bundle.main.path(forResource: "Contacts", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                session.responseData = data
            } catch {
                
            }
        }
        apiManager = CSAPIManager(agent: CSNetworkAgent(session: session))
        homePresenter = CSHomePresenter(delegate: self)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_fetch_contacts() throws {
        expectation = XCTestExpectation(description: "FetchContacts")
        homePresenter.fetchContacts(apiManager: apiManager)
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_fetch_contacts_error() throws {
        session.error = CSError.unknown
        expectation = XCTestExpectation(description: "FetchContacts")
        homePresenter.fetchContacts(apiManager: apiManager)
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_fetch_contacts_outstanding_request_cancel() throws {
        expectation = XCTestExpectation(description: "FetchContacts")
        homePresenter.fetchContacts(apiManager: apiManager)
        homePresenter.fetchContacts(apiManager: apiManager)
        wait(for: [expectation], timeout: 3.0)
    }
}

extension CSHomePresenterTests: CSHomePresenterOutput {
    func contactsFetched(error: CSError?) {
        expectation.fulfill()
        
        if nil == error {
            XCTAssertEqual(homePresenter.numberOfContactsSection(), 2)
            XCTAssertEqual(homePresenter.numberOfContacts(for: 0), 1)
            XCTAssertEqual(homePresenter.numberOfContacts(for: 1), 1)
            XCTAssertEqual(homePresenter.numberOfContacts(for: 2), 0)
            XCTAssert(nil != homePresenter.contact(at: 0, row: 0))
            XCTAssert(nil == homePresenter.contact(at: 0, row: 1))
            XCTAssertEqual(homePresenter.sectionTitles()?.count, 2)
            XCTAssertEqual(homePresenter.sectionTitle(at: 0), "#")
            XCTAssertEqual(homePresenter.sectionTitle(at: 1), "S")
            XCTAssertEqual(homePresenter.sectionTitle(at: 2), nil)
        } else {
            XCTAssertEqual(error, CSError.unknown)
        }
    }
}
