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
    
    var intValue: Int? {
        switch self {
        case .female:
            return 0
        case .male:
            return 1
        default:
            return nil
        }
    }
}

struct UserResponse: Decodable {
    var id: String?
    var name: String?
    var email: String?
    var phone: String?
    var gender: GenderResponse?
    var isVerified: Bool?
    var isOnline: Bool?
    var imageURL: String?
    var instagramURL: String?
    var rate: Float?
    var ratting: Float?
    var reviews: Int?
    var games: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id = "uid"
        case phone = "phoneNumber"
        case gender = "ge"
        case email, name, isVerified, isOnline, imageURL, instagramURL, rate, ratting, reviews, games
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        isVerified = try container.decodeIfPresent(Bool.self, forKey: .isVerified)
        isOnline = try container.decodeIfPresent(Bool.self, forKey: .isOnline)
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        instagramURL = try container.decodeIfPresent(String.self, forKey: .instagramURL)
        rate = try container.decodeIfPresent(Float.self, forKey: .rate)
        ratting = try container.decodeIfPresent(Float.self, forKey: .ratting)
        reviews = try container.decodeIfPresent(Int.self, forKey: .reviews)
        games = try container.decodeIfPresent([String].self, forKey: .games)
        if let genderInt = try container.decodeIfPresent(Int.self, forKey: .gender) {
            gender = GenderResponse(rawValue: genderInt) ?? .unknown
        }
    }
}
