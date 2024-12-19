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
}

struct User {
    var id: String
    var email: String?
    var phone: String?
    var gender: Gender?
}
