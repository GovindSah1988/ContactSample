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
        case email = "email"
        case phoneNumber = "phone_number"
        case detailUrl = "url"
        case image = "image"
    }
    
    let id: Int?
    var firstName: String
    var lastName: String
    var profilePic: String?
    var favorite: Bool?
    var email: String?
    var phoneNumber: String?
    var detailUrl: String?

    // to upload the image to server
    var imageData: Data?
    
    var name: String {
        return firstName.appendNextWord(lastName).capitalized
    }
    
    init(id: Int?) {
        self.id = id
        self.firstName = ""
        self.lastName = ""
        self.profilePic = nil
        self.favorite = false
        self.email = nil
        self.phoneNumber = nil
        self.detailUrl = nil
    }
    
    // MARK: - Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        profilePic = try container.decodeIfPresent(String.self, forKey: .profilePic)
        favorite = try container.decodeIfPresent(Bool.self, forKey: .favorite)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        detailUrl = try container.decodeIfPresent(String.self, forKey: .detailUrl)
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(profilePic, forKey: .profilePic)
        try container.encodeIfPresent(favorite, forKey: .favorite)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(detailUrl, forKey: .detailUrl)
        try container.encodeIfPresent(imageData, forKey: .image)
    }
    
}
