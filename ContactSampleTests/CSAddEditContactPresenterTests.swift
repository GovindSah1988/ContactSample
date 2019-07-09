//
//  CSAddEditContactPresenterTests.swift
//  ContactSampleTests
//
//  Created by Govind Sah on 09/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import XCTest
@testable import ContactSample

class CSAddEditContactPresenterTests: XCTestCase {

    let session = CSMockURLSession()
    var apiManager: CSAPIManager!
    var presenter: CSAddEditContactPresenter!
    
    var expectation: XCTestExpectation!
    var contact: CSContact!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        apiManager = CSAPIManager(agent: CSNetworkAgent(session: session))
        presenter = CSAddEditContactPresenter(delegate: self)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_add_contact_detail() throws {
        if let path = Bundle.main.path(forResource: "ContactAdd", ofType: "json") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let contactDetailResponse = CSContactDetailResponse(data: data)
            contact = contactDetailResponse?.contact
            session.responseData = data
        }
        expectation = XCTestExpectation(description: "AddContactDetail")
        presenter.addEdit(contact: contact, editMode: CSContactEditMode.add, apiManager: apiManager)
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_add_contact_detail_error() throws {
        if let path = Bundle.main.path(forResource: "ContactAdd", ofType: "json") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let contactDetailResponse = CSContactDetailResponse(data: data)
            contact = contactDetailResponse?.contact
            session.responseData = data
        }
        session.error = CSError.unknown
        expectation = XCTestExpectation(description: "AddContactDetailError")
        presenter.addEdit(contact: contact, editMode: CSContactEditMode.add, apiManager: apiManager)
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_add_contact_detail_outstanding_request_cancel() throws {
        if let path = Bundle.main.path(forResource: "ContactAdd", ofType: "json") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let contactDetailResponse = CSContactDetailResponse(data: data)
            contact = contactDetailResponse?.contact
            session.responseData = data
        }
        expectation = XCTestExpectation(description: "AddContactDetailOutstanding")
        presenter.addEdit(contact: contact, editMode: CSContactEditMode.add, apiManager: apiManager)
        presenter.addEdit(contact: contact, editMode: CSContactEditMode.add, apiManager: apiManager)
        wait(for: [expectation], timeout: 3.0)
    }

    func test_edit_contact_detail() throws {
        if let path = Bundle.main.path(forResource: "ContactDetailEdit", ofType: "json") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let contactDetailResponse = CSContactDetailResponse(data: data)
            contact = contactDetailResponse?.contact
            session.responseData = data
        }
        expectation = XCTestExpectation(description: "EditContactDetail")
        presenter.addEdit(contact: contact, editMode: CSContactEditMode.edit, apiManager: apiManager)
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_edit_contact_detail_error() throws {
        if let path = Bundle.main.path(forResource: "ContactDetailEdit", ofType: "json") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let contactDetailResponse = CSContactDetailResponse(data: data)
            contact = contactDetailResponse?.contact
            session.responseData = data
        }
        session.error = CSError.unknown
        expectation = XCTestExpectation(description: "EditContactDetailError")
        presenter.addEdit(contact: contact, editMode: CSContactEditMode.edit, apiManager: apiManager)
        wait(for: [expectation], timeout: 3.0)
    }

}

extension CSAddEditContactPresenterTests: CSAddEditContactPresenterOutput {
    func didFinishAddEdit(contact: CSContact?, error: CSError?) {
        expectation.fulfill()
        if let error = error {
            XCTAssertEqual(error, CSError.unknown)
        } else if let contact = contact {
            XCTAssertEqual(contact.name, self.contact.name)
        }
    }
}
