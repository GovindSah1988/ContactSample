//
//  CSContactDetailResponse.swift
//  ContactSample
//
//  Created by Govind Sah on 08/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

struct CSContactDetailResponse: CSResponseBaseModel, Decodable {
    
    var contact: CSContact?
    
    init?(data: Data?) {
        if let data = data {
            do {
                let decoder = JSONDecoder()
                self.contact = try decoder.decode(CSContact.self, from: data)
            } catch let parsingError {
                print("Error", parsingError)
            }
        } else {
        }
        
    }
    
}
