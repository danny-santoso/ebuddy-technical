//
//  UserRemoteDataSource.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/19/24.
//

import Foundation
import Combine

protocol UserRemoteDataSourceProtocol: AnyObject {
    func getUserList() -> AnyPublisher<[UserResponse], Error>
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
}
