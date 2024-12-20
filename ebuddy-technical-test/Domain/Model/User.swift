//
//  UserEntity.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/19/24.
//

enum Gender {
    case female
    case male
    case unknown
    
    init(response: GenderResponse?) {
        switch response {
        case .female:
            self = .female
        case .male:
            self = .male
        case .unknown, .none:
            self = .unknown
        }
    }
    
    var stringValue: String? {
        switch self {
        case .female:
            return "Female"
        case .male:
            return "Male"
        case .unknown:
            return nil
        }
    }
}

struct User: Identifiable {
    var id: String
    var name: String?
    var email: String?
    var phone: String?
    var gender: Gender?
    var imageURL: String?
    var isVerified: Bool?
    var isOnline: Bool?
    var instagramURL: String?
    var rate: Float?
    var ratting: Float?
    var reviews: Int?
    var games: [String]?
}
