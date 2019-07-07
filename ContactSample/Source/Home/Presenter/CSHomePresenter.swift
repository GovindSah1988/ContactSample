//
//  CSHomePresenter.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

typealias CSContactListResponse = ([CSContact]?, Error?) -> Void

protocol CSHomePresenterOutput: class {
    func contacts(_ contacts: [CSContact]?, error: CSError?)
}

/**
 Protocol that defines the Presenter's use case.
 */
protocol CSHomePresenterInput: class {
    func fetchContacts()
    func numberOfContactsSection() -> Int
    func numberOfContacts(for section: Int) -> Int
    func contact(at section: Int, row: Int) -> CSContact?
}

class CSHomePresenter: NSObject {
    
    // to hold the list of API manager objects
    // in case we need to cancel thme at later point of time
    private var managers: NSMutableArray = []
    
    // weak can never be let as the ARC can set nil to this variable whenever it needs to
    weak private var output: CSHomePresenterOutput?
    
    private var contacts: [CSContact]?
    
    init(delegate: CSHomePresenterOutput) {
        output = delegate
    }
    
}

extension CSHomePresenter: CSHomePresenterInput {
    
    func numberOfContactsSection() -> Int {
        return contacts?.count ?? 0
    }
    
    func numberOfContacts(for section: Int) -> Int {
        return 2
    }
    
    func contact(at section: Int, row: Int) -> CSContact? {
        guard let contacts = contacts, contacts.count > 0 else {
            return nil
        }
        return contacts[0]
    }
    
    func fetchContacts() {
        cancelOutstandingRequests()
        /*
        let request = CSHomeRequest.getContacts
        let apiManager = CSAPIManager()
        managers.add(apiManager)
        apiManager.executeRequest(request: request, responseType: CSContactResponse.self) { [weak self] (response, error) in
            if nil == error, nil != response {
                self?.contacts = response?.result?.assets
                self?.output?.contacts(self?.contacts, error: error as? CSError)
            } else {
                //TODO: handle error cases
                self?.output?.contacts(nil, error: CSError.unknown)
            }
            self?.managers.remove(apiManager)
        }
 */
        // Reading from local json file
        
        fetchData { (contacts, error) in
            if nil == error, let contacts = contacts {
                self.contacts = contacts
                self.output?.contacts(contacts, error: nil)
            } else {
                self.output?.contacts(nil, error: CSError.contactFetchingError)
            }
        }
    }
    
    private func fetchData(completion: CSContactListResponse?) {
        
        if let path = Bundle.main.path(forResource: "Contacts", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let contactResponse = CSContactResponse(data: data)
                completion?(contactResponse?.contacts, nil)
            } catch let error {
                print(error.localizedDescription)
                completion?(nil, error)
            }
        } else {
            print("Invalid filename/path.")
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

extension CSHomePresenter {
    func parseContactsForSections() {
        
    }
}
