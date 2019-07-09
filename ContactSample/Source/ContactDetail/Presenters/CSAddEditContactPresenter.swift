//
//  CSAddEditContactPresenter.swift
//  ContactSample
//
//  Created by Govind Sah on 08/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

protocol CSAddEditContactPresenterOutput: class {
    func didFinishAddEdit(contact: CSContact?, error: CSError?)
}

/**
 Protocol that defines the Presenter's use case.
 */
protocol CSAddEditContactPresenterInput: class {
    func addEdit(contact: CSContact, editMode: CSContactEditMode, apiManager: CSAPIManager)
}

class CSAddEditContactPresenter: NSObject {
    
    // to hold the list of API manager objects
    // in case we need to cancel thme at later point of time
    private var managers: NSMutableArray = []
    
    // weak can never be let as the ARC can set nil to this variable whenever it needs to
    weak private var output: CSAddEditContactPresenterOutput?
    
    init(delegate: CSAddEditContactPresenterOutput) {
        output = delegate
    }
}

extension CSAddEditContactPresenter: CSAddEditContactPresenterInput {
    func addEdit(contact: CSContact, editMode: CSContactEditMode, apiManager: CSAPIManager = CSAPIManager()) {
        cancelOutstandingRequests()
        if .add == editMode {
            addNewContact(contact: contact, apiManager: apiManager)
        } else {
            editContact(contact: contact, apiManager: apiManager)
        }
    }
    
    private func addNewContact(contact: CSContact, apiManager: CSAPIManager) {
        let request = CSHomeRequest.addContact(contact: contact)
        managers.add(apiManager)
        apiManager.executeRequest(request: request, responseType: CSContactDetailResponse.self) { [weak self] (response, error) in
            if nil == error, nil != response {
                self?.output?.didFinishAddEdit(contact: response!.result?.contact, error: nil)
            } else {
                //TODO: handle error cases
                self?.output?.didFinishAddEdit(contact: nil, error: CSError.unknown)
            }
            self?.managers.remove(apiManager)
        }
    }
    
    private func editContact(contact: CSContact, apiManager: CSAPIManager) {
        let request = CSHomeRequest.saveContact(contact: contact)
        managers.add(apiManager)
        apiManager.executeRequest(request: request, responseType: CSContactDetailResponse.self) { [weak self] (response, error) in
            if nil == error, nil != response {
                self?.output?.didFinishAddEdit(contact: response!.result?.contact, error: nil)
            } else {
                //TODO: handle error cases
                self?.output?.didFinishAddEdit(contact: nil, error: CSError.unknown)
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
