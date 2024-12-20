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
    
    func execute(gender: Gender?) -> AnyPublisher<[User], Error> {
        guard let gender else { return repository.getUserList() }
        switch gender {
        case .female:
            return repository.getFemaleUserList()
        default:
            return repository.getUserList()
        }
    }
}
