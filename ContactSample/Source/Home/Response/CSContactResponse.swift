//
//  CSContactResponse.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

struct CSContactResponse: CSResponseBaseModel, Decodable {
    
    var contacts: [CSContact]?
    
    init?(data: Data?) {
        if let data = data {
            do {
                let decoder = JSONDecoder()
                self.contacts = try decoder.decode([CSContact].self, from: data)
            } catch let parsingError {
                print("Error", parsingError)
            }
        } else {
        }
        
    }

}
