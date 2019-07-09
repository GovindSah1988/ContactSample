//
//  CSContactDetailPresenterTests.swift
//  ContactSampleTests
//
//  Created by Govind Sah on 09/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import XCTest
@testable import ContactSample

class CSContactDetailPresenterTests: XCTestCase {

    let session = CSMockURLSession()
    var apiManager: CSAPIManager!
    var contactDetailPresenter: CSContactDetailPresenter!
    
    var expectation: XCTestExpectation!
    var contact: CSContact!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if let path = Bundle.main.path(forResource: "ContactDetail", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let contactDetailResponse = CSContactDetailResponse(data: data)
                contact = contactDetailResponse?.contact
                session.responseData = data
            } catch {
                
            }
        }
        apiManager = CSAPIManager(agent: CSNetworkAgent(session: session))
        contactDetailPresenter = CSContactDetailPresenter(delegate: self)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_fetch_contact_detail() throws {
        expectation = XCTestExpectation(description: "FetchContactDetail")
        contactDetailPresenter.fetchContactDetail(contact: contact, apiManager: apiManager)
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_fetch_contact_detail_error() throws {
        session.error = CSError.unknown
        expectation = XCTestExpectation(description: "FetchContactDetailError")
        contactDetailPresenter.fetchContactDetail(contact: contact, apiManager: apiManager)
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_fetch_contact_detail_outstanding_request_cancel() throws {
        expectation = XCTestExpectation(description: "FetchContactDetailOutstanding")
        contactDetailPresenter.fetchContactDetail(contact: contact, apiManager: apiManager)
        contactDetailPresenter.fetchContactDetail(contact: contact, apiManager: apiManager)
        wait(for: [expectation], timeout: 3.0)
    }

    func test_save_contact_detail() throws {
        expectation = XCTestExpectation(description: "SaveContactDetail")
        contactDetailPresenter.saveContact(contact: contact, apiManager: apiManager)
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_save_contact_detail_error() throws {
        session.error = CSError.unknown
        expectation = XCTestExpectation(description: "SaveContactDetailError")
        contactDetailPresenter.saveContact(contact: contact, apiManager: apiManager)
        wait(for: [expectation], timeout: 3.0)
    }

    func test_delete_contact_detail() throws {
        expectation = XCTestExpectation(description: "DeleteContactDetail")
        contactDetailPresenter.deleteContact(contact: contact, apiManager: apiManager)
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_delete_contact_detail_error() throws {
        session.error = CSError.unknown
        expectation = XCTestExpectation(description: "DeleteContactDetailError")
        contactDetailPresenter.deleteContact(contact: contact, apiManager: apiManager)
        wait(for: [expectation], timeout: 3.0)
    }

}

extension CSContactDetailPresenterTests: CSContactDetailPresenterOutput {
    func detailFetched(contact: CSContact?, error: CSError?) {
        expectation.fulfill()
        if let error = error {
            XCTAssertEqual(error, CSError.unknown)
        } else if let contact = contact {
            XCTAssertEqual(contact.name, self.contact.name)
        }
    }
    
    func deletedContact(contact: CSContact?, error: CSError?) {
        expectation.fulfill()
        if let error = error {
            XCTAssertEqual(error, CSError.unknown)
        } else if let contact = contact {
            XCTAssertEqual(contact.name, self.contact.name)
        }
    }
    
    func detailsUpdated(contact: CSContact?, error: CSError?) {
        expectation.fulfill()
        if let error = error {
            XCTAssertEqual(error, CSError.unknown)
        } else if let contact = contact {
            XCTAssertEqual(contact.name, self.contact.name)
        }
    }
}
