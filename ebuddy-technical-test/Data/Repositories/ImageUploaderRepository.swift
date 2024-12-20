//
//  ImageUploaderRepository.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/20/24.
//

import Foundation
import Combine

protocol ImageUploaderRepositoryProtocol: AnyObject {
    func uploadImage(file data: Data, name fileName: String, type mimeType: String) -> AnyPublisher<ImageUploader, Error>
}

final class ImageUploaderRepository: NSObject {
    
    private let dataSource: ImageUploaderDataSourceProtocol
    
    init(dataSource: ImageUploaderDataSourceProtocol) {
        self.dataSource = dataSource
    }
}

extension ImageUploaderRepository: ImageUploaderRepositoryProtocol {
    func uploadImage(file data: Data, name fileName: String, type mimeType: String) -> AnyPublisher<ImageUploader, Error> {
        return dataSource.uploadImage(file: data, name: fileName, type: mimeType)
            .map { ImageUploaderMapper.mapImageUploaderResponseToDomains(input: $0) }
            .eraseToAnyPublisher()
    }
}
