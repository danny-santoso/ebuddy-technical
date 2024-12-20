//
//  UploadImageUseCase.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/20/24.
//

import Combine
import Foundation

final class UploadImageUseCase {
    private let repository: ImageUploaderRepositoryProtocol
    
    init(repository: ImageUploaderRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(file data: Data, name fileName: String, type mimeType: String) -> AnyPublisher<ImageUploader, Error> {
        return repository.uploadImage(file: data, name: fileName, type: mimeType)
    }
}
