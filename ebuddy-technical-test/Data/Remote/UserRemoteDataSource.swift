//
//  UserRemoteDataSource.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/19/24.
//

import FirebaseFirestore
import Foundation
import Combine

protocol UserRemoteDataSourceProtocol: AnyObject {
    func getUserList() -> AnyPublisher<[UserResponse], Error>
    
    func getFemaleUserList() -> AnyPublisher<[UserResponse], Error>
}

final class UserRemoteDataSource: NSObject {
    
    private let service: FirebaseServiceProtocol
    
    init(service: FirebaseServiceProtocol) {
        self.service = service
    }
}

extension UserRemoteDataSource: UserRemoteDataSourceProtocol {
    func getUserList() -> AnyPublisher<[UserResponse], Error> {
        return service.getDocuments(to: UserResponse.self, collection: FirebaseCollection.users.rawValue)
    }
    
    func getFemaleUserList() -> AnyPublisher<[UserResponse], Error> {
        let filters: [(field: String, value: Any)] = {
            guard let genderFilter = GenderResponse.female.intValue else { return [] }
            return [(field: "ge", value: genderFilter)]
        }()
        
        return service.getDocuments(
            to: UserResponse.self,
            collection: FirebaseCollection.users.rawValue,
            filters: filters,
            sorting: [
                (field: "ratting", descending: true),
                (field: "rate", descending: false)
            ])
    }
}
