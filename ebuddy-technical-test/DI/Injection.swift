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
    
    private func provideImageProfileRepository() -> ImageProfileRepositoryProtocol {
        let firestore = FirebaseService(firestore: Firestore.firestore())
        
        let remote: ImageProfileRemoteDataSource = ImageProfileRemoteDataSource(service: firestore)
        
        return ImageProfileRepository(dataSource: remote)
    }
    
    private func provideUploadImageRepository() -> ImageUploaderRepositoryProtocol {
        let uploaderService = UploaderService()
        
        let remote: ImageUploaderDataSource = ImageUploaderDataSource(service: uploaderService)
        
        return ImageUploaderRepository(dataSource: remote)
    }
    
    func provideFetchUser() -> FetchUserUseCase {
        let repository = provideUserRepository()
        return FetchUserUseCase(repository: repository)
    }
    
    func provideUploadImage() -> UploadImageUseCase {
        let repository = provideUploadImageRepository()
        return UploadImageUseCase(repository: repository)
    }
    
    func provideUpdateImage() -> UpdateImageProfileUseCase {
        let repository = provideImageProfileRepository()
        return UpdateImageProfileUseCase(repository: repository)
    }
}
