//
//  UserUseCase.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/19/24.
//

import Combine

final class FetchUserUseCase {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[User], Error> {
        return repository.getUserList()
    }
}
