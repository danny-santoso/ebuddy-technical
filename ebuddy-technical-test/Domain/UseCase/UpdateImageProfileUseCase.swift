//
//  UpdateImageProfileUseCase.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/22/24.
//

import Combine

final class UpdateImageProfileUseCase {
    
    private let repository: ImageProfileRepositoryProtocol
    
    init(repository: ImageProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(userId: String, imageURL: String) -> AnyPublisher<Void, Error> {
        return repository.updateImageProfile(userId: userId, imageURL: imageURL)
    }
}
