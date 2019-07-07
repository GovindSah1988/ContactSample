//
//  CSContact.swift
//  ContactSample
//
//  Created by Govind Sah on 06/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

struct CSContact: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case favorite = "favorite"
    }
    
    let id: Int?
    let firstName: String
    let lastName: String
    let profilePic: String
    let favorite: Bool
    
    var name: String {
        return firstName.capitalized + " " + lastName.capitalized
    }
    
    // MARK: - Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        profilePic = try container.decode(String.self, forKey: .profilePic)
        favorite = try container.decode(Bool.self, forKey: .favorite)
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(profilePic, forKey: .profilePic)
        try container.encode(favorite, forKey: .favorite)
    }
    
}
