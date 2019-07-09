//
//  CSHomePresenter.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

//typealias CSContactListResponse = ([CSContact]?, Error?) -> Void

protocol CSHomePresenterOutput: class {
    func contactsFetched(error: CSError?)
}

/**
 Protocol that defines the Presenter's use case.
 */
protocol CSHomePresenterInput: class {
    func fetchContacts(apiManager: CSAPIManager)
    func numberOfContactsSection() -> Int
    func numberOfContacts(for section: Int) -> Int
    func contact(at section: Int, row: Int) -> CSContact?
    func sectionTitles() -> [String]?
    func sectionTitle(at section: Int) -> String?
}

class CSHomePresenter: NSObject {
    
    // to hold the list of API manager objects
    // in case we need to cancel thme at later point of time
    private var managers: NSMutableArray = []
    
    // weak can never be let as the ARC can set nil to this variable whenever it needs to
    weak private var output: CSHomePresenterOutput?
    
    private var contactsMappingList = [String: [CSContact]]()

    init(delegate: CSHomePresenterOutput) {
        output = delegate
    }
    
    private func contactsForSection(for section: Int) -> [CSContact] {
        var contactListForSection = [CSContact]()
        guard contactsMappingList.keys.sorted().count > section else {
            return contactListForSection
        }
        let sectionKey = contactsMappingList.keys.sorted()[section]
        contactListForSection = contactsMappingList[sectionKey]!
        return contactListForSection
    }
}

extension CSHomePresenter: CSHomePresenterInput {
    
    func numberOfContactsSection() -> Int {
        return contactsMappingList.keys.count
    }
    
    func numberOfContacts(for section: Int) -> Int {
        return contactsForSection(for: section).count
    }
    
    func contact(at section: Int, row: Int) -> CSContact? {
        let contacts = contactsForSection(for: section)
        guard contacts.count > row else {
            return nil
        }
        return contacts[row]
    }
    
    func sectionTitles() -> [String]? {
        return contactsMappingList.keys.sorted()
    }
    
    func sectionTitle(at section: Int) -> String? {
        let sortedKeys = contactsMappingList.keys.sorted()
        guard sortedKeys.count > section else {
            return nil
        }
        let sectionKey = sortedKeys[section]
        return sectionKey
    }
    
    func fetchContacts(apiManager: CSAPIManager = CSAPIManager()) {
        cancelOutstandingRequests()
        let request = CSHomeRequest.getContacts
        managers.add(apiManager)
        apiManager.executeRequest(request: request, responseType: CSContactResponse.self) { [weak self] (response, error) in
            if nil == error, nil != response {
                self?.parseContactsForSections(contacts: response?.result?.contacts)
                self?.output?.contactsFetched(error: error as? CSError)
            } else {
                //TODO: handle error cases
                self?.output?.contactsFetched(error: CSError.unknown)
            }
            self?.managers.remove(apiManager)
        }
    }
    
    /*
    // Reading from local json file
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
    */
    
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
    func parseContactsForSections(contacts: [CSContact]?) {
        var mappingList = [String: [CSContact]]()
        let validRegExp = "[a-zA-Z]"
        let predicate = NSPredicate(format: "SELF MATCHES %@", validRegExp)
        if let sortedContacts = contacts?.sorted(by: { $0.name <= $1.name }), sortedContacts.count > 0 {
            var lastParsingCharacter = sortedContacts[0].name.first
            if false == predicate.evaluate(with: String(lastParsingCharacter!)) {
                lastParsingCharacter = "#"
            }
            var parsingCharacterRelatedContacts = [CSContact]()
            for contact in sortedContacts {
                var currentParsingCharacter = contact.name.first
                if false == predicate.evaluate(with: String(currentParsingCharacter!)) {
                    currentParsingCharacter = "#"
                }
                if currentParsingCharacter != lastParsingCharacter {
                    mappingList[String(lastParsingCharacter!)] = parsingCharacterRelatedContacts
                    parsingCharacterRelatedContacts = [CSContact]()
                }
                parsingCharacterRelatedContacts.append(contact)
                lastParsingCharacter = currentParsingCharacter
            }
            if parsingCharacterRelatedContacts.count > 0 {
                mappingList[String(lastParsingCharacter!)] = parsingCharacterRelatedContacts
            }
        }
        self.contactsMappingList = mappingList
    }
}
