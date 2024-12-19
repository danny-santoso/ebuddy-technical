//
//  Injection.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/19/24.
//

import Foundation
import FirebaseFirestore

final class Injection: NSObject {
    
    private func provideUserRepository() -> UserRepositoryProtocol {
        let firestore = FirebaseService(firestore: Firestore.firestore())
        
        let remote: UserRemoteDataSource = UserRemoteDataSource(service: firestore)
        
        return UserRepository(dataSource: remote)
    }
    
    func provideFetchUser() -> FetchUserUseCase {
        let repository = provideUserRepository()
        return FetchUserUseCase(repository: repository)
    }
}
