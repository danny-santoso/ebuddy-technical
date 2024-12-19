//
//  UserRepository.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/19/24.
//

import Foundation
import Combine

protocol UserRepositoryProtocol: AnyObject {
    func getUserList() -> AnyPublisher<[User], Error>
}

final class UserRepository: NSObject {
    
    private let dataSource: UserRemoteDataSourceProtocol
    
    init(dataSource: UserRemoteDataSourceProtocol) {
        self.dataSource = dataSource
    }
}

extension UserRepository: UserRepositoryProtocol {
    func getUserList() -> AnyPublisher<[User], Error> {
        return dataSource.getUserList()
            .map { UserMapper.mapUserResponsesToDomains(input: $0) }
            .eraseToAnyPublisher()
    }
}
