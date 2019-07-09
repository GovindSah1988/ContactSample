//
//  CSContactDetailPresenter.swift
//  ContactSample
//
//  Created by Govind Sah on 08/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

protocol CSContactDetailPresenterOutput: class {
    func detailFetched(contact: CSContact?, error: CSError?)
    func deletedContact(contact: CSContact?, error: CSError?)
    func detailsUpdated(contact: CSContact?, error: CSError?)
}

/**
 Protocol that defines the Presenter's use case.
 */
protocol CSContactDetailPresenterInput: class {
    func fetchContactDetail(contact: CSContact)
    func deleteContact(contact: CSContact)
    func saveContact(contact: CSContact)
}

class CSContactDetailPresenter: NSObject {
    
    // to hold the list of API manager objects
    // in case we need to cancel thme at later point of time
    private var managers: NSMutableArray = []
    
    // weak can never be let as the ARC can set nil to this variable whenever it needs to
    weak private var output: CSContactDetailPresenterOutput?
    
    init(delegate: CSContactDetailPresenterOutput) {
        output = delegate
    }

}

extension CSContactDetailPresenter: CSContactDetailPresenterInput {
    func deleteContact(contact: CSContact) {
        cancelOutstandingRequests()
        let request = CSHomeRequest.deleteContact(contact: contact)
        let apiManager = CSAPIManager()
        managers.add(apiManager)
        apiManager.executeRequest(request: request, responseType: CSContactDetailResponse.self) { [weak self] (response, error) in
            if nil == error, nil != response {
                self?.output?.deletedContact(contact: contact, error: nil)
            } else {
                //TODO: handle error cases
                self?.output?.deletedContact(contact: nil, error: CSError.unknown)
            }
            self?.managers.remove(apiManager)
        }
    }
    
    func saveContact(contact: CSContact) {
        let request = CSHomeRequest.saveContact(contact: contact)
        let apiManager = CSAPIManager()
        managers.add(apiManager)
        apiManager.executeRequest(request: request, responseType: CSContactDetailResponse.self) { [weak self] (response, error) in
            if nil == error, nil != response {
                self?.output?.detailsUpdated(contact: response!.result?.contact, error: nil)
            } else {
                //TODO: handle error cases
                self?.output?.detailsUpdated(contact: nil, error: CSError.unknown)
            }
            self?.managers.remove(apiManager)
        }
    }

    func fetchContactDetail(contact: CSContact) {
        cancelOutstandingRequests()
        let request = CSHomeRequest.getContactDetail(contact: contact)
        let apiManager = CSAPIManager()
        managers.add(apiManager)
        apiManager.executeRequest(request: request, responseType: CSContactDetailResponse.self) { [weak self] (response, error) in
            if nil == error, nil != response {
                self?.output?.detailFetched(contact: response!.result?.contact, error: nil)
            } else {
                //TODO: handle error cases
                self?.output?.detailFetched(contact: nil, error: CSError.unknown)
            }
            self?.managers.remove(apiManager)
        }
    }
    
    private func cancelOutstandingRequests() {
        if managers.count > 0 {
            for manager in managers {
                (manager as? CSAPIManager)?.cancelRequest()
            }
            managers.removeAllObjects()
        }
    }

}
