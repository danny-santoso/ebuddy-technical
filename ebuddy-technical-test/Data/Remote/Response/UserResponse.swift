//
//  UserResponse.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/19/24.
//

import Foundation

enum GenderResponse {
    case female
    case male
    case unknown
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .female
        case 1:
            self = .male
        default:
            self = .unknown
        }
    }
}

struct UserResponse: Decodable {
    var id: String?
    var email: String?
    var phone: String?
    var gender: GenderResponse?
    
    enum CodingKeys: String, CodingKey {
        case id = "uid"
        case phone = "phoneNumber"
        case email, gender
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        if let genderInt = try container.decodeIfPresent(Int.self, forKey: .gender) {
            gender = GenderResponse(rawValue: genderInt) ?? .unknown
        }
    }
}
